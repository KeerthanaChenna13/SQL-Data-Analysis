# SQL Data Analysis – Olist Brazilian E-Commerce Dataset

## Project overview
This project uses SQL to explore the Olist Brazilian E-Commerce dataset in
MySQL Workbench. The goal is to practise data retrieval, aggregation,
relationships between tables, subqueries, views, and basic query optimization.

## Tools used
- MySQL Workbench
- MySQL
- Olist Brazilian E-Commerce Dataset (CSV files)

## Database
Database name: `olist_ecommerce`

Tables used:
- `customers`
- `geolocation`
- `order_items`
- `order_payments`
- `order_reviews`
- `orders`
- `products`
- `sellers`
- `category_translation`

## SQL topics covered
1. Basic queries using `SELECT`, `WHERE`, `ORDER BY`, `DISTINCT`, `LIKE`, and `LIMIT`
2. Aggregate functions: `COUNT`, `SUM`, `AVG`, `MAX`, and `MIN`
3. Grouping and filtering groups using `GROUP BY` and `HAVING`
4. `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`
5. Subqueries using `IN`, `EXISTS`, `MAX`, and `ALL`
6. Creating and querying SQL views
7. Creating indexes and examining query plans with `EXPLAIN`

All project queries are saved in `ecommerce_analysis.sql`.

## Dataset
Place the nine original Olist CSV files in the `dataset/` folder. The CSV files
are not bundled in this starter package; add the files you downloaded from
the dataset source before publishing the complete repository.

## Screenshots
Save genuine screenshots from MySQL Workbench in the `screenshots/` folder.
Capture both the SQL statement and its result grid where practical. Suggested
screenshots:
- `basic_queries.png`
- `aggregate_functions.png`
- `joins.png`
- `subqueries.png`
- `views.png`
- `indexes_explain.png`

Do not use fabricated screenshots. If a query returns no rows, capture the
actual result and explain the limitation rather than presenting it as a
successful populated result.

## Data import and validation note
During this project, the `customers` table contained 38,865 rows and the
`orders` table contained 178 rows. The original `olist_orders_dataset.csv`
file was observed to contain 99,442 lines including the header (99,441 data
rows). Therefore, the `orders` import in the working database was incomplete.

The `category_revenue` view was created, but its query returned zero rows in
the current imported data. These limitations mean the current results should
be treated as SQL practice outputs, not as complete or representative
business findings for the full Olist dataset. Re-import and validate the
affected source tables before making final business conclusions.

## How to run
1. Import the CSV files into MySQL Workbench and create/select the
   `olist_ecommerce` database.
2. Open `ecommerce_analysis.sql` in MySQL Workbench.
3. Execute the sections in order, checking the result grid after each query.
4. The two `CREATE INDEX` statements are included as comments because the
   indexes were already created in the working database. Uncomment and run
   them only if those indexes do not already exist.
5. Save screenshots of the actual query outputs in `screenshots/`.

