-- ============================================================
-- PROJECT: SQL for Data Analysis
-- DATASET: Olist Brazilian E-Commerce Dataset
-- DATABASE: olist_ecommerce
-- TOOL: MySQL Workbench
--
-- IMPORTANT DATA NOTE:
-- At the time of this project, customers contained 38,865 rows
-- and orders contained only 178 rows, although the original
-- orders CSV contained 99,442 lines including its header.
-- The category_revenue view returned 0 rows in this import.
-- Do not present results as a complete analysis of the full
-- Olist dataset until the imports and joins are validated.
-- ============================================================

USE olist_ecommerce;

-- ------------------------------------------------------------
-- 1. DATABASE AND TABLE CHECKS
-- ------------------------------------------------------------

SHOW TABLES;

SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_sellers FROM sellers;
SELECT COUNT(*) AS total_payments FROM order_payments;
SELECT COUNT(*) AS total_reviews FROM order_reviews;
SELECT COUNT(*) AS total_geolocation_rows FROM geolocation;
SELECT COUNT(*) AS total_categories FROM category_translation;

-- ------------------------------------------------------------
-- 2. BASIC SQL QUERIES: SELECT, WHERE, ORDER BY, LIMIT
-- ------------------------------------------------------------

-- Display the first 10 customers
SELECT *
FROM customers
LIMIT 10;

-- Customers from the state of Sao Paulo (SP)
SELECT *
FROM customers
WHERE customer_state = 'SP';

-- Sort customers by city
SELECT *
FROM customers
ORDER BY customer_city ASC
LIMIT 20;

-- List distinct customer states
SELECT DISTINCT customer_state
FROM customers;

-- Count customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Count distinct cities
SELECT COUNT(DISTINCT customer_city) AS total_cities
FROM customers;

-- Find cities beginning with the letter 's'
SELECT *
FROM customers
WHERE customer_city LIKE 's%'
LIMIT 20;

-- ------------------------------------------------------------
-- 3. AGGREGATE FUNCTIONS: COUNT, SUM, AVG, MAX, MIN
-- ------------------------------------------------------------

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT SUM(payment_value) AS total_payment_value
FROM order_payments;

SELECT AVG(payment_value) AS average_payment
FROM order_payments;

SELECT MAX(payment_value) AS highest_payment
FROM order_payments;

SELECT MIN(payment_value) AS lowest_payment
FROM order_payments;

-- ------------------------------------------------------------
-- 4. GROUP BY AND HAVING
-- ------------------------------------------------------------

-- Customer count by state
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- Categories with total merchandise revenue above 1000
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING SUM(oi.price) > 1000
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 5. JOINS: INNER JOIN, LEFT JOIN, RIGHT JOIN
-- ------------------------------------------------------------

-- INNER JOIN: matching customers and orders
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
LIMIT 20;

-- LEFT JOIN: all customers and any matching orders
SELECT
    c.customer_id,
    c.customer_city,
    o.order_id,
    o.order_status
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LIMIT 20;

-- RIGHT JOIN: all orders and any matching customers
SELECT
    c.customer_id,
    c.customer_city,
    o.order_id,
    o.order_status
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
LIMIT 20;

-- ------------------------------------------------------------
-- 6. SUBQUERIES
-- ------------------------------------------------------------

-- Customers whose IDs occur in the orders table (IN)
SELECT customer_id, customer_city, customer_state
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);

-- Customers with at least one matching order (EXISTS)
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- Order item(s) with the maximum price
SELECT product_id, price
FROM order_items
WHERE price = (
    SELECT MAX(price)
    FROM order_items
);

-- Prices greater than every product-specific average (ALL)
-- This condition may return no rows; that is a valid outcome.
SELECT product_id, price
FROM order_items
WHERE price > ALL (
    SELECT AVG(price)
    FROM order_items
    GROUP BY product_id
)
LIMIT 20;

-- ------------------------------------------------------------
-- 7. SQL VIEWS
-- ------------------------------------------------------------

-- View joining customer and order details
CREATE OR REPLACE VIEW customer_order_details AS
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

-- Retrieve records from the customer-order view
SELECT *
FROM customer_order_details
LIMIT 20;

-- Business analysis view: category revenue
CREATE OR REPLACE VIEW category_revenue AS
SELECT
    ct.product_category_name_english,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
INNER JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english;

-- Retrieve category revenue
SELECT *
FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 20;

-- List views in the current database
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';

-- ------------------------------------------------------------
-- 8. INDEXES AND QUERY OPTIMIZATION
-- ------------------------------------------------------------

-- The following indexes were created during this project.
-- The columns are TEXT, so a prefix length is specified.
-- These CREATE INDEX statements are commented to prevent
-- duplicate-index errors if this file is run again.
--
-- CREATE INDEX idx_customer_id
-- ON customers(customer_id(50));
--
-- CREATE INDEX idx_orders_customer_id
-- ON orders(customer_id(50));

-- Inspect indexes
SHOW INDEX FROM customers;
SHOW INDEX FROM orders;

-- Inspect table definitions
SHOW CREATE TABLE customers;
SHOW CREATE TABLE orders;

-- EXPLAIN displays MySQL's query execution plan
EXPLAIN
SELECT
    c.customer_id,
    c.customer_city,
    o.order_id,
    o.order_status
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

-- ============================================================
-- END OF PROJECT QUERIES
-- ============================================================
