CREATE TABLE territory (
	SalesTerritoryKey INTEGER,
	Region TEXT,
	Country TEXT,
	Continent TEXT
)
COPY territory FROM 'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Territory Lookup.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE sales (
	OrderDate DATE,
	StockDate DATE,
	ProductKey INTEGER,
	CustomerKey INTEGER,
	TerritoryKey INTEGER,
	OrderLineItem INTEGER,
	OrderQuantity INTEGER

)
COPY sales FROM 'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Sales Data.csv' DELIMITER ',' CSV HEADER;

Create Table return_product (
	ReturnDate DATE,
	TerritoryKey INTEGER,
	ProductKey INTEGER,
	ReturnQuantity INTEGER

)
COPY return_product FROM 'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Returns Data.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE subcategories (
	ProductSubcategoryKey INTEGER,
	SubcategoryName TEXT,
	ProductCategoryKey INTEGER

)

COPY subcategories FROM 'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Product Subcategories Lookup.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE customer (
	CustomerKey INTEGER,
	BirthDate DATE,
	MaritalStatus VARCHAR(3),
	Gender VARCHAR(3),
	AnnualIncome INTEGER,
	TotalChildren INTEGER,
	EducationLevel TEXT,
	Occupation TEXT,
	HomeOwner VARCHAR(3),
	Full_Name VARCHAR(3)
)
ALTER TABLE customer
ALTER COLUMN Full_Name TYPE VARCHAR(255);
COPY customer 
FROM 'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Customer Lookup1.csv' 
WITH (FORMAT csv, HEADER true);
SELECT * FROM customer

CREATE TABLE product (
	ProductKey INTEGER,
	ProductSubcategoryKey INTEGER,
	ProductSKU VARCHAR(256),
	ProductName VARCHAR(256),
	ModelName VARCHAR(256),
	ProductColor TEXT,
	ProductCost NUMERIC,
	ProductPrice NUMERIC
)
COPY product FROM'D:\COURSWE UDEMY\Github Up\Data Science Projects\Adventure_Workshop\Product Lookup1.csv' DELIMITER ',' CSV HEADER;
