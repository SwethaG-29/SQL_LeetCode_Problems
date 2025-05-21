/*
Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.
 

Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.
*/

# Write your MySQL query statement below

-- Solution 1
SELECT 
CASE 
    WHEN MOD(id,2)=0 THEN id -1 
    WHEN MOD(id,2)=1 and id + 1 NOT IN (SELECT id from seat) THEN id 
    ELSE ID+1 
END AS id, student
FROM seat
ORDER BY id;

--  Solution 2
SELECT id,
CASE 
    WHEN id%2 = 0 THEN (LAG(student) OVER (ORDER BY ID))
    ELSE ifnull(LEAD(student) OVER(ORDER BY id),student)
END as "student"
FROM seat;

-- Solution 3
SELECT 
CASE
    WHEN id%2 = 0 THEN id -1 
    WHEN id%2 = 1 and id = (SELECT MAX(id) FROM Seat) THEN id
    ELSE id + 1
END as "id", student
FROM Seat
Order by id;

-- Solution 4

SELECT RANK() OVER( ORDER BY if(id%2 =0,id-1,id+1))  as id, student
FROM Seat;

