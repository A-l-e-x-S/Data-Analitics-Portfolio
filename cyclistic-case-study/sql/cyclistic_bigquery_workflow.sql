-- Cyclistic Case Study (BigQuery Standard SQL)
-- Workflow SQL: data quality checks -> cleaning -> feature engineering -> analysis -> summary tables
-- Author: Alex
-- Notes:
--   1) Replace `project.dataset` with your actual BigQuery project and dataset names.
--   2) This script assumes you already loaded 12 CSV files into:
--        `project.dataset.cyclistic_trips_raw`
--   3) BigQuery Standard SQL is used.

-- ============================================================
-- 0) Quick sanity check: structure & sample rows
-- ============================================================
SELECT *
FROM `project.dataset.cyclistic_trips_raw`
LIMIT 10;

-- Total rows
SELECT COUNT(*) AS total_rows
FROM `project.dataset.cyclistic_trips_raw`;

-- Distinct membership values
SELECT DISTINCT member_casual
FROM `project.dataset.cyclistic_trips_raw`;

-- ============================================================
-- 1) Data integrity checks (critical columns)
-- ============================================================
SELECT
  COUNTIF(ride_id IS NULL) AS null_ride_id,
  COUNTIF(started_at IS NULL) AS null_started_at,
  COUNTIF(ended_at IS NULL) AS null_ended_at,
  COUNTIF(member_casual IS NULL) AS null_member_type
FROM `project.dataset.cyclistic_trips_raw`;

-- Duplicate ride_id count (fast check)
SELECT COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_ids
FROM `project.dataset.cyclistic_trips_raw`;

-- If you want to see the duplicate keys (should return 0 rows if none):
SELECT
  ride_id,
  COUNT(*) AS cnt
FROM `project.dataset.cyclistic_trips_raw`
GROUP BY ride_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- ============================================================
-- 2) Ride duration anomaly checks
-- ============================================================
-- Min / max duration in minutes
SELECT
  MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS min_duration_min,
  MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS max_duration_min
FROM `project.dataset.cyclistic_trips_raw`;

-- Count negative durations and rides longer than 24h (1440 minutes)
SELECT
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 0) AS negative_rides,
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) > 1440) AS over_24h_rides
FROM `project.dataset.cyclistic_trips_raw`;

-- ============================================================
-- 3) Create cleaned table (keep raw table unchanged)
--    Rule: keep durations between 0 and 1440 minutes inclusive
-- ============================================================
CREATE OR REPLACE TABLE `project.dataset.cyclistic_trips_clean` AS
SELECT *
FROM `project.dataset.cyclistic_trips_raw`
WHERE
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 0
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 1440;

-- Row count after cleaning
SELECT COUNT(*) AS cleaned_rows
FROM `project.dataset.cyclistic_trips_clean`;

-- ============================================================
-- 4) Create analytics table (feature engineering)
-- ============================================================
CREATE OR REPLACE TABLE `project.dataset.cyclistic_trips_analytics` AS
SELECT
  *,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minutes,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  EXTRACT(MONTH FROM started_at) AS month,
  EXTRACT(HOUR FROM started_at) AS hour_of_day
FROM `project.dataset.cyclistic_trips_clean`;

-- Verify new columns
SELECT *
FROM `project.dataset.cyclistic_trips_analytics`
LIMIT 10;

-- ============================================================
-- 5) Zero-minute ride investigation (kept as meaningful behavior)
-- ============================================================
-- How many zero-minute rides?
SELECT COUNT(*) AS zero_minute_rides
FROM `project.dataset.cyclistic_trips_analytics`
WHERE ride_length_minutes = 0;

-- Zero-minute rides by membership
SELECT
  member_casual,
  COUNT(*) AS zero_rides
FROM `project.dataset.cyclistic_trips_analytics`
WHERE ride_length_minutes = 0
GROUP BY member_casual
ORDER BY zero_rides DESC;

-- Zero-minute rides as % of each group
SELECT
  member_casual,
  COUNT(*) AS total_rides,
  SUM(CASE WHEN ride_length_minutes = 0 THEN 1 ELSE 0 END) AS zero_rides,
  ROUND(
    SUM(CASE WHEN ride_length_minutes = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2
  ) AS zero_percentage
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual
ORDER BY member_casual;

-- ============================================================
-- 6) Core analysis
-- ============================================================
-- 6.1 Ride duration (average + approximate median)
SELECT
  member_casual,
  ROUND(AVG(ride_length_minutes), 2) AS avg_ride_length,
  ROUND(APPROX_QUANTILES(ride_length_minutes, 2)[OFFSET(1)], 2) AS median_ride_length
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual
ORDER BY member_casual;

-- 6.2 Weekly usage pattern (absolute counts)
SELECT
  member_casual,
  day_of_week,
  COUNT(*) AS total_rides
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, day_of_week
ORDER BY member_casual, total_rides DESC;

-- 6.3 Weekly usage pattern (percent within each group)
SELECT
  member_casual,
  day_of_week,
  COUNT(*) AS total_rides,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, day_of_week
ORDER BY member_casual, percentage_of_group DESC;

-- 6.4 Hourly usage pattern (percent within each group)
SELECT
  member_casual,
  hour_of_day,
  COUNT(*) AS total_rides,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- 6.5 Seasonal trend (percent within each group)
SELECT
  member_casual,
  month,
  COUNT(*) AS total_rides,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, month
ORDER BY member_casual, month;

-- ============================================================
-- 7) Summary tables for Tableau Public (export as CSV)
-- ============================================================
-- 7.1 Duration summary (avg + median)
CREATE OR REPLACE TABLE `project.dataset.duration_summary` AS
SELECT
  member_casual,
  ROUND(AVG(ride_length_minutes), 2) AS avg_ride_length,
  ROUND(APPROX_QUANTILES(ride_length_minutes, 2)[OFFSET(1)], 2) AS median_ride_length
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual;

-- 7.2 Weekly summary (% within group)
CREATE OR REPLACE TABLE `project.dataset.weekly_summary` AS
SELECT
  member_casual,
  day_of_week,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, day_of_week;

-- 7.3 Hourly summary (% within group)
CREATE OR REPLACE TABLE `project.dataset.hourly_summary` AS
SELECT
  member_casual,
  hour_of_day,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, hour_of_day;

-- 7.4 Monthly summary (% within group)
CREATE OR REPLACE TABLE `project.dataset.monthly_summary` AS
SELECT
  member_casual,
  month,
  ROUND(
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual) * 100,
    2
  ) AS percentage_of_group
FROM `project.dataset.cyclistic_trips_analytics`
GROUP BY member_casual, month;

-- ============================================================
-- End of script
-- ============================================================
