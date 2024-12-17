use new_schema_12;


-- WITH selection as 
-- (
-- select Shipping_Mode,d.name, COUNT(o.order_id), Order_Status
-- from orders as O INNER JOIN ordered_items as OT ON O.Order_Id = OT.Order_Id
-- INNER JOIN product_info as P ON OT.item_id = P.product_id 
-- INNER JOIN department d ON P.Department_Id = d.Id
-- group by d.name, Shipping_Mode
-- HAVING (COUNT(Order_Status) = 'COMPLETE' OR COUNT(Order_Status) = 'CLOSED')>=40
-- ) 

WITH ord_ship_summary as 
(
select Shipping_Mode, d.name as dept_name, Order_Status,o.order_id
from orders as O INNER JOIN ordered_items as OT ON O.Order_Id = OT.Order_Id
INNER JOIN product_info as P ON OT.item_id = P.product_id 
INNER JOIN department d ON P.Department_Id = d.Id
),
dep_summary as 
(
select dept_name,COUNT(o.order_id) as count_order_id, Shipping_Mode
 from ord_ship_summary
where order_status IN ('closed' , 'complete')
group by dept_name, Shipping_Mode
)

select dept_name, COUNT(order_id) ,Shipping_Mode from dep_summary
-- where dept_name IN 
-- (
-- select DISTINCT dept_name from dep_summary
-- where count_order_id >=40
-- order by count_order_id DESC)
GROUP BY Shipping_Mode, dept_name;
 


