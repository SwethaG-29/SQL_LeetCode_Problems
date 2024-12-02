Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int);
Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int);
Truncate table Prices;
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30');
Truncate table UnitsSold;
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30');

Select * From Prices;
Select * From UnitsSold;

SELECT u.product_id, IFNULL(round(SUM(p.price * u.units)/sum(u.units),2),0) as average_price
FROM prices as p
LEFT JOIN UnitsSold as u ON p.product_id = u.product_id AND u.purchase_date BETWEEN p.Start_date and p.end_date
GROUP BY u.product_id;


select * from prices as p
LEFT JOIN UnitsSold as u ON p.product_id = u.product_id
