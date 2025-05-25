/*
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id column contains unique values.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
weight is the weight of the person in kilograms.
 

There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

Note that only one person can board the bus at any given turn.

The result format is in the following example.

 

Example 1:

Input: 
Queue table:
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
Output: 
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
Explanation: The folowing table is ordered by the turn for simplicity.
+------+----+-----------+--------+--------------+
| Turn | ID | Name      | Weight | Total Weight |
+------+----+-----------+--------+--------------+
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000         | (last person to board)
| 4    | 2  | Marie     | 200    | 1200         | (cannot board)
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |
+------+----+-----------+--------+--------------+
*/


# Write your MySQL query statement below


 -- Solution 1

WITH CTES as (
SELECT turn, person_id AS ID, person_name as Name, weight, SUM(weight) OVER (ORDER BY turn) AS total_Weight
FROM Queue
),
CTE2 as (
SELECT IF(total_Weight <= 1000, Name, null) as Name, turn
FROM CTES
),

CTE3 as (
SELECT ROW_NUMBER() OVER(ORDER BY Turn DESC) AS rn, name
FROM CTE2
WHERE Name IS NOT NULL 
)

SELECT name as person_name
FROM cte3
WHERE rn = 1;

-- Solution 2

WITH CTES as (
SELECT turn, person_id AS ID, person_name, weight, SUM(weight) OVER (ORDER BY turn) AS total_Weight
FROM Queue
)

SELECT Person_Name 
FROM CTES 
WHERE total_Weight <= 1000
order by turn DESC
LIMIT 1;

-- Solution 3

SELECT person_name
FROM (
SELECT turn, person_id, person_name, weight, SUM(weight) OVER ( ORDER BY turn ROWS UNBOUNDED PRECEDING)AS total_weight
    FROM queue
) AS A
WHERE total_weight <=1000 
ORDER BY person_id DESC 
LIMIT 1;



