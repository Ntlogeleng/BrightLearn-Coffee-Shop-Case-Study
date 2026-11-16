# BrightLearnCoffeeShop CaseStudy

## Project Overview

Data Architecture & Engineering
Source Table
Catalog / Schema: bright_coffee_shop.bright_coffee.coffee_shop_sales

###Key Fields: 
transaction_id, transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail

###Key Data Transformations
Currency & Decimal Normalisation: Converted comma delimited string values in unit_price into DECIMAL(10,2) using the following query:  (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) and standardised currency display formatting to South African Rand (R#,##0.00).

Other Features: Extracted year, month_id, month_name, year_month, day_number, day_name, and grouped timestamps into operational time_bucket (Morning: 06:00–11:59, Lunch: 12:00–16:59, Evening: 17:00–19:59, Night: 20:00+) plus granular 30-minute intervals.

###Key Analytical Insights and Pillars:

###Recommendations:

Align Staffing & Operating Hours with Demand: Concentrate peak barista coverage during the Morning (06:00–11:59) rush per store and evaluate early closing times for locations generating minimal Night bucket revenue.

Introduce Morning Basket Combo: Introduce a "Morning Coffee + Pastry Combo" before 11:00 to lift food-to-beverage attachment rates without relying on new foot traffic.

Create Afternoon Foot Traffic: Run targeted mid-afternoon promotions (14:00–16:59) to smooth out the post-lunch revenue dip.

Optimize Menu & Inventory: Prioritise stock availability for top-performing products and phase out or seasonally rotate bottom-tier menu items.

###Tools & Technologies:
Data Warehouse & Query Engine: Databricks 

Visualisation & Reporting: Excel

Version Control: Git / GitHub

