# Sql_analysis_projects
A collection of SQL analysis projects covering real-world datasets, data cleaning, exploration, and business insights. Built to strengthen my SQL fundamentals and prepare for data analyst interviews.

📦 **Zepto Inventory SQL Analysis**

This project focuses on data cleaning, exploration, and business analytics using the Zepto Inventory dataset.
All SQL queries are written in PostgreSQL.

📁 Dataset Source
Kaggle: Zepto Inventory Dataset by Palvinder — includes product, pricing, discount & inventory details.
https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv



🏗️ Table Schema (PostgreSQL)
CREATE TABLE zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8, 2),
    discountPercent NUMERIC(5, 2),
    discountSellingPrice NUMERIC(8,2),
    weightInGms INT,
    availableQuantity INT,
    outOfStock BOOLEAN,
    quantity INT
);

🔍 Data Exploration
SELECT COUNT(*) FROM zepto;
SELECT * FROM zepto LIMIT 10;
SELECT * FROM zepto;

🔎 Check NULL values
SELECT * FROM zepto
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR discountSellingPrice IS NULL
OR weightInGms IS NULL
OR availableQuantity IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;

📂 Distinct Product Categories
SELECT DISTINCT category FROM zepto ORDER BY category;

📊 Stock Status Breakdown
SELECT outofstock, COUNT(sku_id) FROM zepto GROUP BY outofstock;

🔁 Duplicate Product Names
SELECT name, COUNT(sku_id) AS product_count
FROM zepto GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY product_count DESC;

🧹 Data Cleaning
Remove invalid price data
SELECT * FROM zepto WHERE mrp = 0 OR discountSellingPrice = 0;
DELETE FROM zepto WHERE mrp = 0;

Convert paise → rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountSellingPrice = discountSellingPrice / 100.0;

SELECT mrp, discountSellingPrice FROM zepto;

📈 Business Questions & Insights
1️⃣ Top 5 highest-revenue products

(Helps identify biggest revenue contributors.)

SELECT sku_id, name,
ROUND(SUM(mrp * quantity),2) AS total_revenue
FROM zepto
GROUP BY sku_id, name
ORDER BY total_revenue DESC
LIMIT 5;

2️⃣ Top 10 best-value products (highest discounts)
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

3️⃣ High-MRP products that are out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE
ORDER BY mrp DESC
LIMIT 5;

4️⃣ Category-wise potential revenue estimation
SELECT category,
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

5️⃣ Expensive products (MRP > ₹500) with low discounts (<10%)
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC;

6️⃣ Top discount-offering categories
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount_percent
FROM zepto
GROUP BY category
ORDER BY avg_discount_percent DESC;

7️⃣ Price per gram — value for money analysis
SELECT DISTINCT name, weightInGms, discountSellingPrice,
ROUND(discountSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto;

8️⃣ Weight category segmentation (Low/Medium/Bulk)
SELECT DISTINCT name, weightInGms,
CASE
  WHEN weightInGms < 1000 THEN 'Low'
  WHEN weightInGms < 5000 THEN 'Medium'
  ELSE 'Bulk'
END AS weight_category
FROM zepto;

9️⃣ Total inventory weight per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

🔟 High-demand but low-stock products
SELECT DISTINCT name,
SUM(quantity) AS total_orders,
availableQuantity AS current_stock
FROM zepto
GROUP BY name, availableQuantity
HAVING SUM(quantity) > 50
AND availableQuantity < 20
ORDER BY total_orders DESC, current_stock;

1️⃣1️⃣ Price-sensitive categories (higher discounts → more orders)
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount,
SUM(quantity) AS total_orders
FROM zepto
GROUP BY category
HAVING AVG(discountPercent) > 10
ORDER BY total_orders DESC;
