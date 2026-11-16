-- DATA cleaning and validation --

-- Check for duplicates:

SELECT *,
COUNT(*) AS duplicate_count
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL
HAVING COUNT(*) > 1; -- No duplicates

--Convert Unit_price column into correct format

SELECT
    transaction_id,
    unit_price,
--CAST unit_price
    CAST(REPLACE(unit_price, ',','.') AS DOUBLE) AS unit_price
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales

-- Check the number of records

SELECT 
    COUNT(*) AS total_records
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales; -- total records = 149116


--Check for NULL Values

SELECT *
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
WHERE transaction_id IS NULL OR transaction_date IS NULL OR transaction_time IS NULL OR transaction_qty IS NULL OR store_id IS NULL OR store_location IS NULL OR product_id IS NULL OR unit_price IS NULL OR product_category IS NULL OR product_type IS NULL OR product_detail IS NULL;  -- No Null records found

--PROCESSING--

-- 1.Total Revenue

SELECT
SUM(transaction_qty * (CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2)))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales;

-- 2.Total Revenue per Product_category

SELECT
product_category,
SUM(transaction_qty * CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;

-- 3.Total Revenue per product category and product details

SELECT
product_category,
product_detail,
SUM(transaction_qty * CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;

-- 4.Total revenue per product type

SELECT
product_type,
SUM(transaction_qty * CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;

-- 5. Total units sold
SELECT
    SUM(transaction_qty) AS Total_units
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales;

-- 6. Total revenue per store location

SELECT
    store_location,
    SUM(transaction_qty) AS Total_units
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;

-- 7. Total revenue based on the time of the day
    --Earliest time
    --Latest time

SELECT 
    MIN(transaction_time),
    MAX(transaction_time)
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales;

-- 6AM - 11:59:59 = Morning
-- 12PM - 16:59:59 = Afternoon
-- 17PM - 23:59:59 = Evening
-- 00AM - 05:59:59 = Night


SELECT
 transaction_time,
    CASE 
        WHEN transaction_time BETWEEN '6:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Lunch'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    SUM(transaction_qty * CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;

-- 8. Number of transactions per time bucket

SELECT
    CASE 
        WHEN transaction_time BETWEEN '6:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Lunch'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(transaction_id) AS total_transactions
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;


-- 9. Date extraction Month_name, month_id, day_name

SELECT transaction_date,
MONTHNAME(transaction_date) AS month_name,
MONTH(transaction_date) AS month_id,
DAYNAME(transaction_date) AS day_name,
DATE_FORMAT(transaction_date, 'yyy,MMM') AS month_id,
DAYOFWEEK(transaction_date) AS day_number
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales;


--- COMBINATION OF ABOVE QUERIES--- Final query --

SELECT
transaction_id,
transaction_date,
YEAR(transaction_date) AS year,
MONTHNAME(transaction_date) AS month_name,
MONTH(transaction_date) AS month_id,
DAYNAME(transaction_date) AS day_name,
DATE_FORMAT(transaction_date, 'yyy,MMM') AS month_id,
DAYOFWEEK(transaction_date) AS day_number,
 product_category,
 product_type,
 product_detail,
 store_location,
    CASE 
        WHEN transaction_time BETWEEN '6:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Lunch'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(transaction_id) AS total_transactions, 
    SUM(transaction_qty) AS Total_units,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',','.') AS DECIMAL(10,2)))) AS total_revenue
FROM bright_coffee_shop.bright_coffee.coffee_shop_sales
GROUP BY ALL;