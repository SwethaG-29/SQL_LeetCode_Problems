/* Write a solution to find the ids of products that are both low fat and recyclable.

Return the result table in any order.

The result format is in the following example.*/


Create table If Not Exists Products (
	product_id int,
	low_fats ENUM('Y', 'N'),
	recyclable ENUM('Y','N')
);
 
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');


select product_id
from Products
where low_fats= 'Y' and recyclable= 'Y';