/*
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
*/

# Write your MySQL query statement below

SELECT num as ConsecutiveNums
FROM (SELECT num,
LEAD(num,1) OVER (ORDER BY id) AS Num1,
LAG(NUM, 1) OVER (ORDER BY id) AS Num2
FROM Logs
) as sd
WHERE num = Num1 and Num2 = num and Num2 = Num1
GROUP BY ConsecutiveNums;


SELECT l1.num as ConsecutiveNums
FROM logs as l1 INNER JOIN logs as l2 on l2.id = l1.id + 1 and l1.num = l2.num
INNER JOIN logs as l3 on l3.id = l2.id+1 and l3.num = l2.num

