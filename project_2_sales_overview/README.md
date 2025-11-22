# 📊 **Sales Overview Dashboard — Global Superstore (2011–2014)**

*(Power BI Project)*

This project presents an interactive **Sales Overview Dashboard** built for the *Global Superstore* dataset covering years **2011–2014**.
The dashboard focuses on high-level business performance, including sales trends, profitability, product categories, customer segments, and regional distribution.

Dataset shown in the original assignment: **Global Superstore 2011–2014**.

---

# ⭐ **Key Insights**

* **Total Profit** across regions reached **$3.81B**, with **West, East, Central and South** regions leading in performance.
* **Total Sales** amounted to **$299.75M**, showing strong revenue across all markets.
* **Technology** and **Furniture** show strong category-level activity with **8.4K–8.2K orders**, while **Office Supplies** leads in volume (**19K orders**).
* **Sales Trends Over Time** show a significant increase between **2011 and 2014**, growing from **$62M to $96M**.
* **Consumer Segment** dominates all orders (**51.46%**), followed by Corporate (**30.13%**) and Home Office (**18.41%**).
* Regional profit varies significantly, with the **West ($1.05B)**, **East ($0.92B)**, and **Central ($0.71B)** being the most profitable regions.

---

# 🎯 **Business Questions Answered**

This dashboard answers key business questions such as:

1. What are the total sales and profitability across years 2011–2014?
2. Which product categories generate the highest number of orders?
3. How do sales vary by customer segment?
4. Which regions contribute the most to global profit?
5. How do sales trends evolve over time?

---

# 📈 **Dashboard Visuals**

### **1. KPI Cards**

* Total Profit
* Total Sales

### **2. Sales Trends Over Time**

Line chart showing year-over-year growth (2011–2014).

### **3. Orders by Product Category**

Bar chart representing count of orders in:

* Office Supplies
* Technology
* Furniture

### **4. Sales by Country**

Map visual showing category-wise sales distribution.

### **5. Orders by Segment**

Donut chart showing distribution between:

* Consumer
* Corporate
* Home Office

### **6. Total Profit by Region**

Column chart showing regional profitability.

---

# 🧮 **DAX Measures Used**

```DAX
Total Sales = SUM('Global_Superstore'[Sales])
Total Profit = SUM('Global_Superstore'[Profit])
```

---

# 📂 **Project Structure**

```
project_2_sales_overview/
│
├── data/
│   └── Global-Superstore.xlsx
│
├── visuals/
│   ├── dashboard.png
│   ├── orders_by_product_category.png
│   ├── sales_trends_over_time.png
│
├── Global Superstore.pbix
├── Global Superstore.pdf
└── README.md
```
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
