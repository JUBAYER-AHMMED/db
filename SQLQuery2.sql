select title, au_fname + ' '+ au_lname as author_name
from titles
join titleauthor on titles.title_id = titleauthor.title_id 
join authors on titleauthor.au_id = authors.au_id

SELECT title,au_fname + ' '+ au_lname as author_name, pub_name
from titles
join titleauthor on titles.title_id = titleauthor.title_id
join authors on titleauthor.au_id = authors.au_id
join publishers on publishers.pub_id = titles.pub_id

SELECT name FROM sys.tables;

SELECT au_lname, pub_name FROM authors, publishers 

--task 2
SELECT 
    a.au_lname AS AuthorLastName,
    a.city AS AuthorCity,
    p.pub_name AS PublisherName,
    p.city AS PublisherCity
FROM 
    authors a
CROSS JOIN 
    publishers p;

--III
SELECT 
    a.au_fname + ' ' + a.au_lname AS AuthorName,
    a.city AS AuthorCity,
    p.pub_name AS PublisherName,
    p.city AS PublisherCity
FROM 
    authors a
CROSS JOIN 
    publishers p
WHERE 
    a.city = p.city;


--3
SELECT * FROM titles WHERE royalty = (SELECT avg(royalty) FROM titles) 

CREATE TABLE CustomerAndSuppliers (
    cusl_id CHAR(6) PRIMARY KEY CHECK (cusl_id LIKE 'C[0-9][0-9][0-9][0-9][0-9]' OR cusl_id LIKE 'S[0-9][0-9][0-9][0-9][0-9]'),
    cusl_fname VARCHAR(15) NOT NULL,
    cusl_lname VARCHAR(15),
    cusl_address TEXT,
    cusl_telno CHAR(12) CHECK (cusl_telno LIKE '[0-9][0-9][0-9]%-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    cusl_city CHAR(12) DEFAULT 'Rajshahi',
    sales_amnt MONEY CHECK (sales_amnt >= 0),
    proc_amnt MONEY CHECK (proc_amnt >= 0)
);


INSERT INTO CustomerAndSuppliers (
    cusl_id, cusl_fname, cusl_lname, cusl_address, cusl_telno, cusl_city, sales_amnt, proc_amnt
) VALUES (
    'C12345', 'Ali', 'Hassan', '123 Green Road, Dhaka', '017-1234567', 'Dhaka', 5000, 0
);

select * from CustomerAndSuppliers;


CREATE TABLE Employee2(
ID CHAR(5) PRIMARY KEY CHECK (ID LIKE 'A[0-9][0-9][0-9][0-9]'),
FName VARCHAR(10) NOT NULL,
LName VARCHAR(10),
phone_no char(12) CHECK (phone_no LIKE '[0-9][0-9][0-9]%-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
address_ TEXT,
role_ VARCHAR(50),
salary MONEY CHECK(salary >=0) ,
);

--insert 1
INSERT INTO Employee2(
ID, FName,LName,phone_no,address_,role_,salary) 
VALUES('A1234','JUBAYER','AHMMED','017-10146797','Bogura','Senior Software Engineer', 500000)

--2
INSERT INTO Employee2(
ID, FName,LName,phone_no,address_,role_,salary) 
VALUES('A1235','AMANUR','RAHMAN','017-10138474','Bogura','GENERAL MANAGER', 500000)

--3
INSERT INTO Employee2(
ID, FName,LName,phone_no,address_,role_,salary) 
VALUES('A1236','OWASIQUR','RAHMAN','017-32138474','Dhaka','CIVIL ENGINEER', 500000)


select * from Employee2;

--drop the table
DROP TABLE Employee2;


CREATE TABLE Item(
item_id CHAR(6) PRIMARY KEY CHECK (item_id LIKE 'P[0-9][0-9][0-9][0-9][0-9]'),
item_name CHAR(12),
item_category CHAR(10),
item_price float(12) CHECK (item_price>=0),
item_qoh integer check (item_qoh >= 0),
item_last_sold Date,
);

INSERT INTO Item(
item_id,item_name,item_category,item_price,item_qoh,item_last_sold
)
VALUES(
'P00001','Chips','Snacks',15.00,2,'2025-06-07'

)
--second item
INSERT INTO Item(
item_id,item_name,item_category,item_price,item_qoh,item_last_sold
)
VALUES(
'P00002','Bread','Snacks',25.00,3,'2025-06-09'
)
select * from Item;

--task 4.2

CREATE TABLE Transactions (
    tran_id CHAR(10) PRIMARY KEY CHECK (tran_id LIKE 'T[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    item_id CHAR(6),
    cust_id CHAR(6),
    tran_type CHAR(1) CHECK (tran_type = 'S' OR tran_type = 'O'),
    tran_quantity INTEGER CHECK (tran_quantity >= 0),
    tran_date DATETIME,
    
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (cust_id) REFERENCES CustomerAndSuppliers(cusl_id)
);


INSERT INTO Transactions(
tran_id,item_id,cust_id,tran_type,tran_quantity,tran_date
)
VALUES(
'T000000001','P00001','C12345','S',1,'2025-06-09 14:30:00'
) 

select * from Transactions;