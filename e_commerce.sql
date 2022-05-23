drop database if exists e_commerce;
create database e_commerce;
use e_commerce;


drop table if exists Supplier; 
CREATE TABLE Supplier (
    SUPP_ID INT PRIMARY KEY,
    SUPP_NAME VARCHAR(50),
    SUPP_CITY VARCHAR(50),
    SUPP_PHONE VARCHAR(10)
);

drop table if exists Customer;
CREATE TABLE Customer (
    CUS_ID INT,
    CUS_NAME VARCHAR(50),
    CUS_PHONE VARCHAR(10),
    CUS_CITY VARCHAR(50),
    CUS_GENDER CHAR,
    PRIMARY KEY (CUS_ID)
);

drop table if exists Category;
CREATE TABLE Category (
    CAT_ID INT,
    CAT_NAME VARCHAR(50),
    PRIMARY KEY (CAT_ID)
);

drop table if exists Product;
CREATE TABLE Product (
    PRO_ID INT,
    PRO_NAME VARCHAR(50),
    PRO_DESC VARCHAR(75),
    CAT_ID INT,
    PRIMARY KEY (PRO_ID),
    FOREIGN KEY (CAT_ID) REFERENCES Category(CAT_ID)    
);

drop table if exists ProductDetails;
CREATE TABLE ProductDetails (
    PROD_ID INT,
    PRO_ID INT,
    SUPP_ID INT,
    PRICE INT,
    PRIMARY KEY (PROD_ID),
    FOREIGN KEY(PRO_ID) REFERENCES Product(PRO_ID),
	FOREIGN KEY(SUPP_ID) REFERENCES Supplier(SUPP_ID)
);

drop table if exists Orders;
CREATE TABLE Orders (
    ORD_ID INT,
    ORD_AMOUNT INT,
    ORD_DATE DATE,
    CUS_ID INT,
    PROD_ID INT,
    PRIMARY KEY (ORD_ID),
    FOREIGN KEY(CUS_ID) REFERENCES Customer(CUS_ID),
    FOREIGN KEY(PROD_ID) REFERENCES ProductDetails(PROD_ID)
    );
    
drop table if exists Rating;
CREATE TABLE Rating (
    RAT_ID INT,
    CUS_ID INT,
    SUPP_ID INT,
    RAT_RATSTARS INT,
    PRIMARY KEY (RAT_ID),
    FOREIGN KEY(SUPP_ID) REFERENCES Supplier(SUPP_ID),
    FOREIGN KEY(CUS_ID) REFERENCES Customer(CUS_ID) 
);


INSERT INTO Supplier values(1, "Rajesh Retails", "Delhi", 1234567890);
INSERT INTO Supplier values(2, "Appario Ltd.", "Mumbai", 2589631470);
INSERT INTO Supplier values(3, "Knome products", "Banglore", 9785462315);
INSERT INTO Supplier values(4, "Bansal Retails", "Kochi", 8975463285);
INSERT INTO Supplier values(5, "Mittal Ltd.", "Lucknow", 7898456532);

INSERT INTO Customer values(1, "AAKASH", 9999999999, "Delhi", 'M');
INSERT INTO Customer values(2, "AMAN", 9785463215, "NOIDA", 'M');
INSERT INTO Customer values(3, "NEHA", 9999999999, "MUMBAI", 'F');
INSERT INTO Customer values(4, "MEGHA", 9994562399, "KOLKATA", 'F');
INSERT INTO Customer values(5, "PULKIT", 7895999999, "LUCKNOW", 'M');

INSERT INTO Category values(1, "BOOKS");
INSERT INTO Category values(2, "GAMES");
INSERT INTO Category values(3, "GROCERIES");
INSERT INTO Category values(4, "ELECTRONICS");
INSERT INTO Category values(5, "CLOTHES");

INSERT INTO Product values(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
INSERT INTO Product values(2, "TSHIRT", "DFDFJDFJDKFD", 5);
INSERT INTO Product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
INSERT INTO Product values(4, "OATS", "REURENTBTOTH", 3);
INSERT INTO Product values(5, "HARRY POTTER", "NBEMCTHTJTH", 1);

INSERT INTO ProductDetails values(1, 1, 2, 1500);
INSERT INTO ProductDetails values(2, 3, 5, 30000);
INSERT INTO ProductDetails values(3, 5, 1, 3000);
INSERT INTO ProductDetails values(4, 2, 3, 2500);
INSERT INTO ProductDetails values(5, 4, 1, 1000);

INSERT INTO Orders values(20, 1500, "2021-10-12", 3, 5);
INSERT INTO Orders values(25, 30500, "2021-09-16", 5, 2);
INSERT INTO Orders values(26, 2000, "2021-10-05", 1, 1);
INSERT INTO Orders values(30, 3500, "2021-08-16", 4, 3);
INSERT INTO Orders values(50, 2000, "2021-10-06", 2, 1);

INSERT INTO Rating values(1, 2, 2, 4);
INSERT INTO Rating values(2, 3, 4, 3);
INSERT INTO Rating values(3, 5, 1, 5);
INSERT INTO Rating values(4, 1, 3, 2);
INSERT INTO Rating values(5, 4, 5, 4);

/* SOLUTION 3 */
SELECT 
    CUS_GENDER, COUNT(CUS_GENDER)
FROM
    Customer c
        JOIN
    orders o ON o.CUS_ID = c.CUS_id
WHERE
    o.ORD_AMOUNT >= 3000
GROUP BY c.CUS_GENDER;

/* SOLUTION 4 */
SELECT 
    *
FROM
    Orders o
        JOIN
    ProductDetails p ON o.PROD_ID = p.PROD_ID
        JOIN
    Product pr ON pr.PRO_ID = p.PRO_ID
WHERE
    o.CUS_ID = 2; 
    
/* SOLUTION 5 */
SELECT 
    *
FROM
    Supplier
WHERE
    SUPP_ID IN (SELECT 
            SUPP_ID
        FROM
            ProductDetails
        GROUP BY SUPP_ID
        HAVING COUNT(SUPP_ID) > 1);
    
/* SOLUTION 6 */
SELECT 
    c.*
FROM
    Orders o
        JOIN
    ProductDetails pd ON pd.PROD_ID = o.PROD_ID
        JOIN
    Product p ON p.PRO_ID = pd.PRO_ID
        JOIN
    Category c ON c.CAT_ID = p.CAT_ID
HAVING MIN(o.ORD_AMOUNT);	

/* SOLUTION 7 */
SELECT 
    p.PRO_ID, p.PRO_NAME
FROM
    Orders o
        JOIN
    ProductDetails pd ON (o.PROD_ID = pd.PROD_ID)
        JOIN
    Product p ON (p.PRO_ID = pd.PRO_ID)
WHERE
    o.ORD_DATE > '2021-10-05';
    
/* SOLUTION 8 */
SELECT 
    s.SUPP_ID, s.SUPP_NAME, c.CUS_NAME, r.RAT_RATSTARS
FROM
    Rating r
        JOIN
    Supplier s ON (r.SUPP_ID = s.SUPP_ID)
        JOIN
    Customer c ON (r.CUS_ID = c.CUS_ID)
ORDER BY r.RAT_RATSTARS DESC
LIMIT 3;

/* SOLUTION 9 */
SELECT 
    CUS_NAME
FROM
    Customer
WHERE
    CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';
    
/* SOLUTION 10 */
SELECT 
    SUM(o.ORD_AMOUNT)
FROM
    Orders o,
    Customer c
WHERE
    c.CUS_ID = o.CUS_ID
        AND c.CUS_GENDER = 'M';
        
/* SOLUTION 11 */
SELECT 
    *
FROM
    Customer
        LEFT OUTER JOIN
    Orders ON Customer.CUS_ID = Orders.CUS_ID;