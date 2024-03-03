/* Total Revenue */
SELECT ROUND(SUM(pr.Productprice * s.orderquantity)/1000000,2) as Total_Revenue_million 
FROM sales s
join product pr
on s.productkey = pr.productkey

/* Total Profit */
SELECT ROUND( (SUM(pr.Productprice * s.orderquantity)- SUM(pr.Productcost * s.orderquantity))/1000000,2)
as Total_Profit
FROM sales s
join product pr
on s.productkey = pr.productkey

/* Total Orders */
SELECT COUNT(DISTINCT ordernumber) as Total_order 
from sales

/* Total Quantity SOLD */
SELECT sum(sa.orderquantity) AS Quantity_sold
from sales sa

/* Total Quantity Returned */
SELECT sum(re.returnquantity) AS Quantity_returned
from return_product re

/* Total Returns */
SELECT count(re.returnquantity) AS Total_Returns
from return_product re

/* Return Rate */
SELECT ROUND( CAST(sum(re.returnquantity)*100 AS DECIMAL(10,2))/
(SELECT CAST(sum(sa.orderquantity) as decimal(10,2)) from sales sa), 2) as Return_Rate_pct
from return_product re

/* Revenue by Month */
SELECT TO_CHAR(s.orderdate, 'Month') AS Month_name,
Round(SUM(pr.Productprice * s.orderquantity)/1000000,2) as Total_Revenue_million
FROM sales s
join product pr
on s.productkey = pr.productkey
group by Month_name
Order by Total_Revenue_million DESC

/* Sales, Revenue & Most Profitable Product subcategory */
SELECT sub.subcategoryname as product_subcat,COUNT(DISTINCT sa.ordernumber ) as Total_order,
Round(SUM(pr.Productprice * sa.orderquantity)/1000,3) as Total_Revenue_K,
ROUND( (SUM(pr.Productprice * sa.orderquantity)- SUM(pr.Productcost * sa.orderquantity))/1000,2)
as Total_Profit_k
FROM sales sa
join product pr
on sa.productkey = pr.productkey
join subcategories sub
on sub.productsubcategorykey = pr.productsubcategorykey
Group by product_subcat
order by Total_profit_k DESC

/* Unique Customer */
SELECT COUNT(DISTINCT customerkey) As Total_Customer
from customer

/* Average Revenue per Customer */
SELECT Round(CAST(SUM(pr.Productprice * sa.orderquantity) AS DECIMAL(10,2))/
CAST(COUNT(DISTINCT cu.customerkey) AS DECIMAL(10,2)),2) as Average_Revenue_per_Customer
FROM sales sa
join customer cu
on sa.customerkey = cu.customerkey
join product pr
on pr.productkey = sa.productkey

/* Revenue & Sales by Customer [TOP 100] */
SELECT cu.full_name as Customer_Name,COUNT(DISTINCT sa.ordernumber ) as Total_order, 
SUM(pr.Productprice * sa.orderquantity) as Total_Revenue
FROM sales sa
join customer cu
on sa.customerkey = cu.customerkey
join product pr
on pr.productkey = sa.productkey
group by Customer_Name
Order by Total_Revenue DESC
LIMIT 100

/*Orders Education Level*/
SELECT cu.educationlevel as Education, COUNT(DISTINCT sa.ordernumber ) as Total_order
FROM customer cu
RIGHT join sales sa
on sa.customerkey = cu.customerkey
group by Education
Order by Total_order DESC

/*Orders By Occupation*/
SELECT cu.occupation as Education, COUNT(DISTINCT sa.ordernumber ) as Total_order
FROM customer cu
RIGHT join sales sa
on sa.customerkey = cu.customerkey
group by occupation
Order by Total_order DESC

Select * FROM customer

/* Checking 5 Number Summary*/
SELECT MIN(annualincome) AS min_salary,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY annualincome) AS q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annualincome) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY annualincome) AS q3,
    MAX(annualincome) AS max_salary
FROM customer;

/* Orders by Income level */
SELECT COUNT(DISTINCT sa.ordernumber ) as Total_order,
case when cu.annualincome <= 30000 then 'Low'
	 when cu.annualincome between 30000 and 70000 THEN 'MEDIUM'
	 WHEN cu.annualincome >= 70000 then 'High'
	 end as Income_Level
FROM customer cu
RIGHT join sales sa
on sa.customerkey = cu.customerkey
group by Income_level
Order by Total_order DESC

/* Weekly orders by customers */
SELECT TO_CHAR(date_trunc('week', sa.orderdate), 'YYYY-MM-DD') AS start_of_week ,
COUNT(DISTINCT cu.customerkey) as Total_order
from sales sa
join customer cu
on cu.customerkey = sa.customerkey
GROUP BY start_of_week

/* Daily orders by customers */
SELECT TO_CHAR(sa.orderdate ,'Day') as Day_Name ,
COUNT(DISTINCT cu.customerkey) as Total_order
from sales sa
join customer cu
on cu.customerkey = sa.customerkey
GROUP BY Day_Name


/* Revenue & Sales by Region */
SELECT ter.region as Region,COUNT(DISTINCT sa.ordernumber ) as Total_order, 
SUM(pr.Productprice * sa.orderquantity) as Total_Revenue
FROM sales sa
join territory ter
on sa.territorykey = ter.salesterritorykey
join product pr
on pr.productkey = sa.productkey
group by Region
Order by Total_Revenue DESC

/* Revenue & Sales by Continent */
SELECT ter.continent as continent,COUNT(DISTINCT sa.ordernumber ) as Total_order, 
SUM(pr.Productprice * sa.orderquantity) as Total_Revenue
FROM sales sa
join territory ter
on sa.territorykey = ter.salesterritorykey
join product pr
on pr.productkey = sa.productkey
group by continent
Order by Total_Revenue DESC

/* Revenue & Sales by Country */
SELECT ter.country as country,COUNT(DISTINCT sa.ordernumber ) as Total_order, 
SUM(pr.Productprice * sa.orderquantity) as Total_Revenue
FROM sales sa
join territory ter
on sa.territorykey = ter.salesterritorykey
join product pr
on pr.productkey = sa.productkey
group by country
Order by Total_Revenue DESC

/* Most Customers by country */
SELECT COUNT(DISTINCT cu.customerkey) as Customer_number,ter.country as country
from customer cu
join sales sa
on cu.customerkey = sa.customerkey
join territory ter
on ter.salesterritorykey = sa.territorykey
group by country
order by Customer_number DESC

/* Most Customers by continent */
SELECT COUNT(DISTINCT cu.customerkey) as Customer_number,ter.continent as continent
from customer cu
join sales sa
on cu.customerkey = sa.customerkey
join territory ter
on ter.salesterritorykey = sa.territorykey
group by continent
order by Customer_number DESC

/* Return Quantity by country Using CTE */
WITH returned_quantity AS (
    SELECT ter.country AS country,COALESCE(SUM(re.returnquantity), 0) AS quantity_returned
    FROM territory ter
    JOIN return_product re ON re.territorykey = ter.salesterritorykey
    GROUP BY country),
ordered_quantity AS (
    SELECT ter.country AS country, COALESCE(SUM(sa.orderquantity), 0) AS quantity_ordered
    FROM territory ter
    LEFT JOIN sales sa ON sa.territorykey = ter.salesterritorykey
    GROUP BY country)
SELECT r.country,
       r.quantity_returned,
       o.quantity_ordered,
	   CASE 
           WHEN o.quantity_ordered = 0 THEN NULL
           ELSE Round(cast(r.quantity_returned as decimal(10,2)) *100 / 
					  cast(o.quantity_ordered as decimal(10,2)),2)
       END AS return_rate
FROM returned_quantity r
FULL OUTER JOIN ordered_quantity o ON r.country = o.country
ORDER BY return_rate DESC;

/* Product with most Return rate*/
WITH returned_quantity AS (
    SELECT sub.subcategoryname AS Product_Subcat,COALESCE(SUM(re.returnquantity), 0) AS quantity_returned
    FROM return_product re
    JOIN product pr ON re.productkey = pr.productkey
	join subcategories sub on pr.productsubcategorykey = sub.productsubcategorykey
    GROUP BY Product_Subcat
),
ordered_quantity AS (
	SELECT sub.subcategoryname AS Product_Subcat,COALESCE(SUM(sa.orderquantity), 0) AS quantity_ordered
    FROM sales sa
    JOIN product pr ON sa.productkey = pr.productkey
	join subcategories sub on pr.productsubcategorykey = sub.productsubcategorykey
    GROUP BY Product_Subcat)
SELECT r.Product_subcat,
       r.quantity_returned,
       o.quantity_ordered,
	   CASE 
           WHEN o.quantity_ordered = 0 THEN NULL
           ELSE Round(cast(r.quantity_returned as decimal(10,2)) *100 / 
					  cast(o.quantity_ordered as decimal(10,2)),2)
       END AS return_rate
FROM returned_quantity r
FULL OUTER JOIN ordered_quantity o ON r.Product_subcat = o.Product_subcat
ORDER BY return_rate DESC;









