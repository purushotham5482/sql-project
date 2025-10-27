

CREATE table ZEPTO_V2(
SKU_ID SERIAL PRIMARY KEY,
CATEGORY VARCHAR(120),
NAME VARCHAR(120) NOT NULL,
MRP NUMERIC(8,2),
DISCOUNTPERCENT NUMERIC(5,2),
AVAILABLEQUANTITY INTEGER,
DISCOUNTEDSELLIINGPRICE NUMERIC(8,2),
WEIGHTINGMS INT,
OUTOFSTOCK BOOLEAN,
QUANTITY INT
);

SELECT * FROM ZEPTO_V2


SELECT * FROM ZEPTO_V2
LIMIT 10;

SELECT * FROM ZEPTO_V2
WHERE NAME IS NULL
OR
category IS NULL
OR
 MRP IS NULL
OR
DISCOUNTPERCENT IS NULL
OR
AVAILABLEQUANTITY IS NULL
OR
 discountedselliingprice IS NULL
OR
WEIGHTINGMS IS NULL
OR
OUTOFSTOCK IS NULL
OR
 QUANTITY IS NULL;


--DIFFERENT PRODUCT CATEGORIES

SELECT distinct Category
FROM ZEPTO_V2
order by Category;

--PRODUCTS IN STOCK VS OUT OF STOCK

SELECT OUTOFSTOCK,COUNT(SKU_ID)
FROM ZEPTO_V2
GROUP BY  OUTOFSTOCK;


--PRODUCT NAMES PRESENT IN MULTIPLE TIMES

SELECT NAME,COUNT(SKU_ID) AS "NUMBER OF SKU_ID"
FROM ZEPTO_V2
GROUP BY NAME
HAVING COUNT(SKU_ID)>1
ORDER BY COUNT(SKU_ID) DESC;

--DATA CLEANING

--PRODUCT WITH PRICE=0

SELECT * FROM ZEPTO_V2
WHERE MRP=0 AND discountedselliingprice=0;

DELETE FROM ZEPTO_V2
WHERE MRP=0;

--CONVERT PAISE TO RUPEES

UPDATE ZEPTO_V2
SET MRP=MRP/100.0,
discountedselliingprice=discountedselliingprice/100.0;

SELECT * FROM ZEPTO_V2;

SELECT mrp,discountedselliingprice FROM ZEPTO_V2;

--1. Found top 10 best-value products based on discount percentage


 SELECT DISTINCT NAME,MRP,discountpercent
from zepto_v2
ORDER BY discountpercent DESC
LIMIT 10;


--2. Identified high-MRP products that are currently out of stock

SELECT DISTINCT NAME,MRP
FROM ZEPTO_V2
WHERE OUTOFSTOCK=TRUE AND MRP>300
ORDER BY MRP DESC;


--3. Estimated potential revenue for each product category

SELECT CATEGORY,
SUM(discountedselliingprice * availablequantity) AS TOTAL_REVENUE
FROM ZEPTO_V2
GROUP BY CATEGORY
ORDER BY  TOTAL_REVENUE;

--4. Filtered expensive products (MRP > ₹500) with minimal discount

SELECT DISTINCT NAME,MRP,discountpercent
FROM ZEPTO_V2
WHERE MRP>500 AND discountpercent < 10
ORDER BY MRP DESC,discountpercent DESC;


--Ranked top 5 categories offering highest average discounts

SELECT CATEGORY,
ROUND(AVG(discountpercent),2) AS AVG_DISCOUNT
FROM ZEPTO_V2
GROUP BY CATEGORY
ORDER BY AVG_DISCOUNT DESC
LIMIT 5;

--Calculated price per gram to identify value-for-money products

SELECT DISTINCT NAME,weightingms,discountedselliingprice,
ROUND(discountedselliingprice/weightingms,2) AS PRICE_PER_GRAM
FROM ZEPTO_V2
WHERE weightingms>=100
ORDER BY PRICE_PER_GRAM;

--Grouped products based on weight into Low, Medium, and Bulk categories


 SELECT DISTINCT NAME,weightingms,
 CASE WHEN weightingms < 1000 THEN 'Low'
      WHEN weightingms < 5000 THEN 'Medium'
      ELSE 'Bulk'
      END AS WEIGHTED_CATEGORY
      FROM ZEPTO_V2;
  

--Measured total inventory weight per product category

   select DISTINCT CATEGORY,
   SUM(availablequantity * weightingms) AS TOTAL_WEIGHT
   FROM ZEPTO_V2
   GROUP BY CATEGORY
   ORDER BY TOTAL_WEIGHT;
   
