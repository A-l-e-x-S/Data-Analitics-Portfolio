# 📊 **Sales Performance Dashboard — Global Superstore (2012–2015)**

This project presents an interactive **Power BI dashboard** built on the *Global Superstore* dataset.
The goal is to analyze sales performance, profitability, and category/regional trends to identify business opportunities and areas for optimization.

Dataset used: **Global Superstore 2012–2015**

---

## 🧠 **Key Insights**

* **Technology** — leader in both profit (**145K**) and sales (**0.76M**).
* **Furniture** — stable medium profit (**82K**).
* **Office Supplies** — lowest profit (**62K**), requires discount & pricing analysis.
* **Best quarter:** Q4 — peak values for both sales and profit.
* **Best year:** 2015 — highest totals (**Sales: 0.61M, Profit: 104K**).
* **Average profit margin:** **19%**, indicating strong business efficiency.

---

## 🎯 **Business Objectives**

The dashboard answers the following key questions:

1. Which product categories drive the highest sales and profit?
2. How do sales and profit change across quarters and years?
3. Which regions perform best in terms of sales and profitability?
4. What is the overall profitability structure of the business?
5. Which categories or regions need further optimization?

---

## 🧮 **Metrics & DAX Measures**

### **Total Sales**

```DAX
Total Sales = SUM('Global_Superstore(CSV)'[Sales])
```

### **Total Profit**

```DAX
Total Profit = SUM('Global_Superstore(CSV)'[Profit])
```

### **Profit Margin**

```DAX
Profit Margin =
DIVIDE([Total Profit], [Total Sales])
```

Conditional formatting thresholds:

* **Profit Margin**

  * < 5% — Bad (Red)
  * 5–15% — Neutral (Yellow)
  * > 15% — Good (Green)

* **Total Profit**

  * ≤ 75,000 — Bad
  * 75,000–120,000 — Neutral
  * ≥ 120,000 — Good

---

## 📈 **Dashboard Visuals**

### **1. KPI Cards**

* Total Profit by Category
* Profit Margin by Category
  Highlighted with conditional formatting rules.

### **2. Category Performance**

* *Sum of Sales and Profit by Category*
* *Quantity Distribution by Category (Pie Chart)*

### **3. Regional Performance**

* *Sum of Sales by Region and Category (Azure Maps)*
  Pie chart bubbles show category distribution by region.

### **4. Trend Analysis**

* *Total Sales & Profit by Quarter*
* *Total Sales & Profit by Year*

These charts show consistent growth with clear seasonal patterns.

---

## 🗂️ **Project Structure**

```
project_1_sales_dashboard/
│
├── data/
│   └── Global_Superstore(CSV).xlsx
│
├── visuals/
│   ├── dashboard.png
│   ├── sales_by_region_and_category_map.png
│   └── category_chart.png
│
├── Global Superstore.pbix
├── Global Superstore.pdf
└── README.md
```

---

## 💡 **Tools Used**

* **Power BI** — data modeling, DAX, visualization
* **Power Query** — data transformation
* **Excel** — initial checks

---

## 📬 **Author**

**Aleksandr Svirskii**
Data Analyst | Information Science Graduate

* Email: [asvirskii.job@gmail.com](mailto:asvirskii.job@gmail.com)
* LinkedIn: [https://www.linkedin.com/in/aleksandr-svirskii-800b00316](https://www.linkedin.com/in/aleksandr-svirskii-800b00316)
* GitHub: [https://github.com/A-l-e-x-S](https://github.com/A-l-e-x-S)

---

## ⭐ **If you like this project**

Feel free to ⭐ the repository or reach out!
This dashboard is part of a growing portfolio of analytics projects.

---
