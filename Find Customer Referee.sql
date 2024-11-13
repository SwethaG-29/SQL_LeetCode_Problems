Create table If Not Exists Customer (
id int, name varchar(25), referee_id int
);

insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

select * from Customer
where referee_id <> 2 is not false;

-- or

select * from customer
where referee_id != 2 or referee_id is null;
