/*
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
*/


SELECT product_id,change_date,
CASE WHEN (change_date) = '2019-08-16' THEN new_price 
WHEN MIN(change_date) > '2019-08-16' THEN 10
ELSE new_price
END as price
FROM Products
GROUP BY product_id;

-- ---------------------------------

WITH t1 as (
SELECT DISTINCT product_id, FIRST_VALUE(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) as price
FROM Products
WHERE change_date<='2019-08-16'
)

SELECT * FROM t1 

UNION 

SELECT product_id, 10 as price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM t1 );


select distinct product_id, new_price as price
from Products
where (product_id, change_date) in (
    select product_id, max(change_date)
    from Products
    where change_date <= '2019-08-16'
    group by product_id
);

SELECT product_id, new_price AS price
FROM Products
WHERE (product_id, change_date) IN (
                SELECT product_id, MAX(change_date)
                FROM Products
                WHERE change_date <= '2019-08-16'
                GROUP BY product_id
                )


UNION 

SELECT product_id, 10 as price
FROM Products
GROUP BY product_id
HAVING min(change_date) > '2019-08-16'
ORDER BY product_id ASC;


