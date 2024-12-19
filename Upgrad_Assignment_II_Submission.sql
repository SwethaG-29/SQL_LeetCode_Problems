use supply_db ;

/*  Question: Month-wise NIKE sales

	Description:
		Find the combined month-wise sales and quantities sold for all the Nike products. 
        The months should be formatted as ‘YYYY-MM’ (for example, ‘2019-01’ for January 2019). 
        Sort the output based on the month column (from the oldest to newest). The output should have following columns :
			-Month
			-Quantities_sold
			-Sales
		HINT:
			Use orders, ordered_items, and product_info tables from the Supply chain dataset.
*/		



WITH nikey_pdt as(
select Product_Name,product_id from product_info
WHERE Product_Name LIKE '%Nike%'
)
SELECT DATE_FORMAT(O.Order_Date,'%Y-%m') as Month, SUM(OI.Quantity) as Quantities_sold,SUM(  OI.sales) as Sales
from orders as O 
inner join ordered_items as OI ON O.Order_Id = OI.Order_Id
inner join nikey_pdt as N on N.product_id = OI.Item_Id
GROUP BY DATE_FORMAT(O.Order_Date,'%Y-%m')
ORDER BY month ASC;

-- **********************************************************************************************************************************
/*

Question : Costliest products

Description: What are the top five costliest products in the catalogue? Provide the following information/details:
-Product_Id
-Product_Name
-Category_Name
-Department_Name
-Product_Price

Sort the result in the descending order of the Product_Price.

HINT:
Use product_info, category, and department tables from the Supply chain dataset.


*/
 select product_id, Product_name, C.Name as category_Name,d.Name as department_Name,Product_Price
 from Category as c inner join product_info as pi on c.id = pi.Category_id
 inner join department as d on d.id = pi.department_id
 GROUP BY product_id, Product_name,category_Name,department_Name
 HAVING MAX(Product_Price)
 ORDER BY MAX(Product_Price) DESC
 limit 5;
-- **********************************************************************************************************************************

/*

Question : Cash customers

Description: Identify the top 10 most ordered items based on sales from all the ‘CASH’ type orders. 
Provide the Product Name, Sales, and Distinct Order count for these items. Sort the table in descending
 order of Order counts and for the cases where the order count is the same, sort based on sales (highest to
 lowest) within that group.
 
HINT: Use orders, ordered_items, and product_info tables from the Supply chain dataset.


*/


SELECT p.Product_Name,SUM(oi.Sales) AS Total_Sales,COUNT(DISTINCT oi.Order_Id) AS Order_Count
FROM product_info p INNER JOIN ordered_items oi ON p.Product_Id = oi.Item_Id
INNER JOIN orders o ON oi.Order_Id = o.Order_Id
WHERE o.Type = 'CASH'
GROUP BY p.Product_Name
ORDER BY Order_Count DESC, Total_Sales DESC
LIMIT 10;

-- **********************************************************************************************************************************
/*
Question : Customers from texas

Obtain all the details from the Orders table (all columns) for customer orders in the state of Texas (TX),
whose street address contains the word ‘Plaza’ but not the word ‘Mountain’. The output should be sorted by the Order_Id.

HINT: Use orders and customer_info tables from the Supply chain dataset.

*/

SELECT o.* 
FROM orders AS o INNER JOIN customer_info AS c ON c.id = o.Customer_Id
WHERE c.state = 'TX' AND c.Street LIKE '%Plaza%' AND c.Street NOT LIKE '%Mountain%'
ORDER BY O.Order_Id;

-- **********************************************************************************************************************************
/*
 
Question: Home office

For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging to
“Apparel” or “Outdoors” departments. Compute the total count of such orders. The final output should contain the 
following columns:
-Order_Count

*/

select COUNT(distinct O.Order_Id) as Order_Count 
from customer_info as c LEFT JOIN orders as o on o.Customer_Id = c.id
INNER JOIN ordered_items as oi using(Order_Id)
INNER JOin product_info as p on p.Product_id = oi.Item_Id 
INNER JOIN department as d on p.Department_Id = d.id
where c.Segment = 'Home Office' and (d.Name = 'Apparel' or d.Name ='Outdoors');


-- **********************************************************************************************************************************
/*

Question : Within state ranking
 
For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging
to “Apparel” or “Outdoors” departments. Compute the count of orders for all combinations of Order_State and Order_City. 
Rank each Order_City within each Order State based on the descending order of their order count (use dense_rank). 
The states should be ordered alphabetically, and Order_Cities within each state should be ordered based on their rank. 
If there is a clash in the city ranking, in such cases, it must be ordered alphabetically based on the city name. 
The final output should contain the following columns:
-Order_State
-Order_City
-Order_Count
-City_rank

HINT: Use orders, ordered_items, product_info, customer_info, and department tables from the Supply chain dataset.

*/

WITH FilteredOrderCounts AS (
    SELECT CI.State AS Order_State, CI.City AS Order_City, COUNT(DISTINCT O.Order_Id) AS Order_Count
    FROM orders O
    INNER JOIN customer_info CI ON O.Customer_Id = CI.Id
    INNER JOIN ordered_items OI ON O.Order_Id = OI.Order_Id
    INNER JOIN product_info PI ON OI.Item_Id = PI.Product_Id
    INNER JOIN department D ON PI.Department_Id = D.Id
    WHERE CI.Segment = 'Home Office' AND D.Name IN ('Apparel', 'Outdoors')
    GROUP BY CI.State, CI.City
)

SELECT Order_State, Order_City, Order_Count,
DENSE_RANK() OVER (PARTITION BY Order_State ORDER BY Order_Count DESC, Order_City ASC) AS City_Rank
FROM FilteredOrderCounts
ORDER BY Order_State ASC, City_Rank ASC, Order_City ASC;

-- **********************************************************************************************************************************
/*
Question : Underestimated orders

Rank (using row_number so that irrespective of the duplicates, so you obtain a unique ranking) the 
shipping mode for each year, based on the number of orders when the shipping days were underestimated 
(i.e., Scheduled_Shipping_Days < Real_Shipping_Days). The shipping mode with the highest orders that meet 
the required criteria should appear first. Consider only ‘COMPLETE’ and ‘CLOSED’ orders and those belonging to 
the customer segment: ‘Consumer’. The final output should contain the following columns:
-Shipping_Mode,
-Shipping_Underestimated_Order_Count,
-Shipping_Mode_Rank

HINT: Use orders and customer_info tables from the Supply chain dataset.


*/

WITH FilteredOrders AS (
    SELECT 
        EXTRACT(YEAR FROM O.Order_Date) AS Order_Year,
        O.Shipping_Mode,
        COUNT(O.Order_Id) AS Shipping_Underestimated_Order_Count
    FROM 
        orders O
    JOIN 
        customer_info CI ON O.Customer_Id = CI.Id
    WHERE 
        O.Order_Status IN ('COMPLETE', 'CLOSED')
        AND CI.Segment = 'Consumer'
        AND O.Scheduled_Shipping_Days < O.Real_Shipping_Days
    GROUP BY 
        EXTRACT(YEAR FROM O.Order_Date), 
        O.Shipping_Mode
),
RankedShippingModes AS (
    SELECT 
        Order_Year,
        Shipping_Mode,
        Shipping_Underestimated_Order_Count,
        ROW_NUMBER() OVER (
            PARTITION BY Order_Year 
            ORDER BY Shipping_Underestimated_Order_Count DESC, Shipping_Mode ASC
        ) AS Shipping_Mode_Rank
    FROM 
        FilteredOrders
)
SELECT 
    Shipping_Mode,
    Shipping_Underestimated_Order_Count,
    Shipping_Mode_Rank
FROM 
    RankedShippingModes
ORDER BY 
    Order_Year, 
    Shipping_Mode_Rank;

-- **********************************************************************************************************************************




