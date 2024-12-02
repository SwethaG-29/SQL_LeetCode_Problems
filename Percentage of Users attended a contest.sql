Create table If Not Exists Users (user_id int, user_name varchar(20));
Create table If Not Exists Register (contest_id int, user_id int);


Truncate table Users;
insert into Users (user_id, user_name) values ('6', 'Alice');
insert into Users (user_id, user_name) values ('2', 'Bob');
insert into Users (user_id, user_name) values ('7', 'Alex');
Truncate table Register;
insert into Register (contest_id, user_id) values ('215', '6');
insert into Register (contest_id, user_id) values ('209', '2');
insert into Register (contest_id, user_id) values ('208', '2');
insert into Register (contest_id, user_id) values ('210', '6');
insert into Register (contest_id, user_id) values ('208', '6');
insert into Register (contest_id, user_id) values ('209', '7');
insert into Register (contest_id, user_id) values ('209', '6');
insert into Register (contest_id, user_id) values ('215', '7');
insert into Register (contest_id, user_id) values ('208', '7');
insert into Register (contest_id, user_id) values ('210', '2');
insert into Register (contest_id, user_id) values ('207', '2');
insert into Register (contest_id, user_id) values ('210', '7');

select r.contest_id,((COUNT( DISTINCT r.user_id)/COUNT( DISTINCT u.user_id))*100) AS percentage
from Users as u LEFT join Register as r using(user_id)
GROUP BY r.contest_id;



select r.contest_id,(COUNT(r.contest_id)/(select COUNT(u.user_id) from users as u )*100) AS percentage
FROM Register as r
GROUP BY r.contest_id;


select r.contest_id
FROM Register as r
where r.user_id in (select user_id , (COUNT(r.contest_id)/(COUNT(u.user_id))*100 ) from users as u)













