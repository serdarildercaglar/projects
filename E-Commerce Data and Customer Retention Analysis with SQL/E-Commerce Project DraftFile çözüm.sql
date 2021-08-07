

--DAwSQL Session -8 

--E-Commerce Project Solution



--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

SELECT Customer_Name,Province,Region,Customer_Segment, A.Cust_id,B.Ord_id,D.Prod_id,E.Ship_id,Sales,Discount
		order_quantity,Product_Base_Margin,Order_Date,Order_Priority,Product_Category,Product_Sub_Category,Order_ID
		,Ship_Mode,Ship_Date

into combined_table

from cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
		where A.Cust_id = B.Cust_id
		and B.Ord_id = C.Ord_id
		and B.Prod_id = D.Prod_id
		and B.Ship_id = E.Ship_id


select * 

		
		from cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
		where A.Cust_id = B.Cust_id
		and B.Ord_id = C.Ord_id
		and B.Prod_id = D.Prod_id
		and B.Ship_id = E.Ship_id

		

--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

select top 3 Customer_Name, COUNT(Order_ID) numbers_of_order from combined_table
group by Customer_Name
order by numbers_of_order desc



select top 3 customer_name, COUNT(ord_id) as number_of_orders from combined_table
group by Customer_Name
order by number_of_orders desc

select top 3 customer_name, COUNT(Order_ID) as number_of_orders from combined_table
group by Customer_Name
order by number_of_orders desc

--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.


SET DATEFORMAT dmy  -- year month day olan format� day month year olarak tantt�k

-- SELECT datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as A from combined_table 

update combined_table set order_date =  CONVERT(DATE,order_date,103) -- s�tunlar�n t�r d�n���mlerini yapt�k
update combined_table set Ship_Date =  CONVERT(DATE,Ship_Date,103)  -- s�tunlar�n t�r d�n���mlerni yapt�k
select order_date, ship_date, DATEDIFF(D, order_Date, ship_date) from combined_table  -- t�r d�n���m� i�lemi ba�ar�l�

-- DaysTakenForDelivery ad�nda yeni bir s�tun olu�turduk
alter table combined_table add DaysTakenForDelivery int
-- oluturdu�umuz yeni s�tuna de�erlerimizi at�yoruz
update combined_table set DaysTakenForDelivery = DATEDIFF(D,Order_Date, Ship_Date)
-- s�tun de�erlerini kontrol ediyoruz. 

select Order_Date,Ship_Date, DaysTakenForDelivery, DATEDIFF(D,Order_Date,Ship_Date) as date_diff
from combined_table  
order by date_diff-- de�erler uyu�uyor




/* create view tablo as 
select *, datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as DaysTakenForDelivery
from combined_table */







--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"



select top 1 Customer_Name, Order_Date, Ship_Date, DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery desc 


SELECT TOP 1 FIRST_VALUE(customer_name) OVER(ORDER BY DaysTakenForDelivery DESC)FROM combined_table

SELECT MAX(DaysTakenForDelivery),Customer_NameFROM combined_tablegroup by Customer_NameHAVING MAX(DaysTakenForDelivery) = (SELECT MAX(DaysTakenForDelivery)								    FROM combined_table								    )

--////////////////////////////////



--5. Count the total number of unique customers in January / and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


-- Count the total number of unique customers in January
select count(distinct Cust_id) as unique_customer_in_January
from combined_table
--where MONTH(Order_Date ) = 1
where DATENAME(MONTH,Order_Date) = 'January'

-- how many of them came back every month over the entire year in 2011

select datename(Month,order_date) as month_name,Month(order_date) as month_number,  COUNT(cust_id) as come_back 
from combined_table

where cust_id in (
select distinct Cust_id
from combined_table
where MONTH(Order_Date ) = 1)

and year(order_date ) = 2011
group by datename(Month,order_date),Month(order_date)
order by Month(order_date)


select cust_id, order_date from combined_table
where Cust_id = 'Cust_55'
order by Order_Date


--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions

create view first as
(select * from (
				select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date )  [rownum1]
				from combined_table) F
where F.rownum1 = 1)


create view third as
(select * from (
				select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date ) [rownum3]
				from combined_table) F
where F.rownum3 = 3)

select T.Customer_Name, DATEDIFF(D,f.Order_Date, T.Order_Date) as elapsed_time_from_orders from first F, third T
where F.Cust_id = T.Cust_id
order by elapsed_time_from_orders desc






--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions

-- 11 ve 14 �r�nleri alan m��teriler

select cust_id,Customer_Name
from combined_table
where Prod_id = 'Prod_11'
intersect
select cust_id,Customer_Name
from combined_table
where Prod_id = 'Prod_14'

-- 11 ve 14 � alanlar�n ald�klar� toplam �r�n say�s�
with cte as (
select Cust_id, Customer_Name, COUNT(Order_ID) as number_of_orders
from combined_table
where Cust_id in (
					select distinct cust_id
					from combined_table
					where Prod_id = 'Prod_11'
					intersect
					select distinct Cust_id
					from combined_table
					where Prod_id = 'Prod_14')
group by Cust_id, Customer_Name)
select SUM(number_of_orders) from cte


-- 11 ya da 14 � toplam al�m say�s�
select 
-- oranlar�
select 210.0 /448
select cast(210 as float) / 448
-- 11 ve 14 ten ald�klar� adet say�s�
--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. 
(For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.
create view tablo as 
select Cust_id, YEAR(Order_Date) as year, MONTH(Order_Date) as month
from combined_table;

select * from tablo

--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

create view number_of_monthly_visits as
select Cust_id, month(Order_Date) as month ,count(MONTH(Order_Date)) as number_of_visit
from combined_table
group by Cust_id, month(Order_Date)









--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
create view next_month_visit as
select 	*, 	lead(monthh,1) over(partition by customer_name order by monthh) as next_visit_monthfrom (	  select 		Customer_Name,		MONTH(order_date) as monthh, 		dense_rank() over(partition by customer_name order by MONTH(order_date)) dens	  from combined_table	  ) as a

--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

select *,	next_visit_month - monthhfrom next_month_visit;





--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.
with cte as (
select *,	next_visit_month - monthh as difffrom next_month_visit) 

select *
		
from cte




--/////////////////////////////////////




--MONTH-W�SE RETENT�ON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!