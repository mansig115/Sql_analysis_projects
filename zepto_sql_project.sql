create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8, 2),
discountPercent NUMERIC(5, 2),
availabl
)


--data exploration

Select count(*) from zepto;

Select * from zepto limit 10;

Select * from zepto;

-- null data
Select * from zepto
where name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories

Select Distinct category from zepto order by category;

-- products in stock vs out of stock products

Select outofstock, count(sku_id) from zepto group by outofstock;


-- product names present multiple times

Select name, count(sku_id) as product_count from zepto group by name
having count(sku_id) > 1 order by count(sku_id) desc;

-- data cleaning

-- removing data = 0

Select * from zepto where mrp = 0 OR discountSellingPrice = 0;

Delete from zepto where mrp = 0;

-- convert paise into rupees
Update zepto SET mrp = mrp / 100.0,
discountSellingPrice = discountSellingPrice / 100.0;

Select mrp, discountSellingPrice from zepto;


-- Business Questions

-- 1. Find the top 5 highest-revenue products.
Select sku_id, name, round(SUM(mrp * quantity),2) as total_revenue from 
zepto group by sku_id, name order by total_revenue desc limit 5;



-- 2 Found top 10 best-value products based on discount percentage
Select distinct name,  mrp, discountpercent from zepto 
order by discountpercent desc limit 10;


-- 3 Identify high-MRP products that are currently out of stock
SELECT Distinct name, mrp FROM zepto WHERE outOfStock = TRUE
ORDER BY mrp DESC limit 5;


-- 4 Estimate potential revenue for each product category

Select category, sum(discountsellingprice * availablequantity) as
total_revenue from zepto group by category order by total_revenue;


-- 5 Filter expensive products (MRP > ₹500) and discount less than 10%
Select distinct name, mrp, discountpercent from zepto where mrp > 500 and discountpercent < 10
order by mrp desc;

-- 6 Rank top 5 categories offering highest average discounts
Select category, round(avg(discountpercent),2) as avg_discount_percent from zepto
group by category order by avg_discount_percent desc;



-- 7 Calculated price per gram to identify value-for-money products
Select Distinct name, weightingms, discountsellingprice, 
round(discountsellingprice/weightingms, 2) as price_per
as price from zepto 

-- 8 Grouped products based on weight into Low, Medium, and Bulk categories
Select Distinct name, weightingms,
case when weightingms < 1000 then 'Low'
when weightingms < 5000 then 'Medium'
else 'Bulk' end as weight_categories
from zepto;

--9  Measure total inventory weight per product category
Select category, sum(weightingms * availablequantity) as total_weight
from zepto group by category
order by total_weight desc;


-- 10 What products have high demand but low stock?
Select Distinct name, sum(quantity) as total_orders,
availablequantity as current_stock from zepto 
group by name, availablequantity having sum(quantity) > 50 -- high demand
and availablequantity < 20 --low stock
order by total_orders desc, 
current_stock;

-- 11 What categories are price-sensitive (high discounts → high orders)?
Select category,
round(avg(discountpercent),2) as avg_discount,
sum(quantity) as total_orders from zepto 
group by category Having avg(discountpercent) > 10
order by total_orders desc;