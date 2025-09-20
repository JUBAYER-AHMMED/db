--Discussion: 2 --

use pubs;
go
select name from sys.tables;

--1
select au_lname , title_id , authors.au_id
from authors join titleauthor
on authors.au_id = titleauthor.au_id;

--task:1
select * from titles;
select * from titleauthor;
select * from authors;
select * from publishers;
--(i)
select title ,au_fname, au_lname 
from titles join titleauthor on titles.title_id = titleauthor.title_id
join authors on authors.au_id = titleauthor.au_id;
--(ii)
select title ,au_fname, au_lname ,pub_name
from titles join titleauthor on titles.title_id = titleauthor.title_id
join authors on authors.au_id = titleauthor.au_id
join publishers on publishers.pub_id = titles.pub_id;


--2
select au_lname, pub_name from authors,publishers;

--task:2
select au_lname, authors.city,pub_name , publishers.city 
from authors, publishers 
where authors.city = publishers.city;

--or
select au_lname, authors.city,pub_name , publishers.city 
from authors join publishers 
on authors.city = publishers.city;

--3: Nested Query
select avg(royalty) from titles;

select * from titles where royalty = (select avg(royalty) from titles);
--task:3
--(iv)
select au_lname,royalty from authors join titleauthor on authors.au_id = titleauthor.au_id
join titles on titles.title_id = titleauthor.title_id
where royalty = (select max(royalty) from titles);

-------------------
----4--------
--table creation--
create table CandS
(
  cus_id char(6) primary key check(cus_id like '[CS][0-9][0-9][0-9][0-9][0-9]'),
  cus_fname char(15) not null,
  cus_lname varchar(15) ,
  cus_address text,
  cus_telno char(12) check (cus_telno like '[0][1][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  cus_city varchar(12) default 'Rajshahi',
  sales_amnt money ,
  proc_amnt money
)

--------------
---5----
--insertion
insert into CandS 
(cus_id,cus_fname,cus_lname,cus_address,cus_telno,cus_city,sales_amnt,proc_amnt)
values
('C00001','Jubayer','Ahmmed', 'Charmatha','017-10146797','Bogura',10000,2000),
('C00002','Md','Ridoy', 'Namuza','017-10786797','Dinajpur',8000,1200),
('C00003','Kabir','Ahmed', 'Dhanmondi','017-10149097','Dhaka',9000,1500);

insert into CandS 
(cus_id,cus_fname,cus_lname,cus_address,cus_telno,cus_city,sales_amnt,proc_amnt)
values
('S00001','Arif','Ahmmed', 'Charmatha','018-10146797','Bogura',10000,2000),
('S00002','Arefin','Ridoy', 'Namuza','019-10786797','Dinajpur',8000,1200),
('S00003','Ariful','Ahmed', 'Dhanmondi','015-10149097','Dhaka',9000,1500);


select * from CandS;

---Item Table--
create table Item
(
  item_id char(6) primary key check ( item_id like 'P[0-9][0-9][0-9][0-9][0-9]'),
  item_name varchar(12),
  item_category varchar(10),
  item_price float(12) check(item_price >= 0 ),
  item_qoh int check(item_qoh >= 0 ),
  item_last_sold date default getdate()
)
--insert into Item table:
insert into Item
(item_id,item_name,item_category,item_price,item_qoh,item_last_sold)
values
('P00001','Biriyani', 'Food', 250,100, convert(date,'12-09-2025',105)),--since date is taken in the form YYYY-MM--DD
('P00002','Laptop', 'Electrical',100000,50,convert(date, '15-09-2025',105)),
('P00003','AntiVirus', 'Software', 2500,500, convert(date,'18-09-2025',105));

create table transactions
(
  tran_id char(10) primary key check (tran_id like 'T[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  item_id char(6) foreign key references Item(item_id),
  cus_id char(6) foreign key references CandS(cus_id),
  tran_type char(1) check(tran_type in ('S','O')),
  tran_quantity int check (tran_quantity > 0),
  tran_date date default getdate(),
)

insert into transactions
(tran_id,item_id,cus_id,tran_type,tran_quantity,tran_date)
values
('T000000001','P00001','C00001','S', 5, convert(date,'19-09-25',5)),
('T000000002','P00002','C00002','S', 8, convert(date,'19-09-25',5)),
('T000000003','P00003','C00002','S', 10, convert(date,'19-09-25',5)),
('T000000004','P00001','S00001','O', 15, convert(date,'19-09-25',5)),
('T000000005','P00002','S00001','O', 6, convert(date,'19-09-25',5)),
('T000000006','P00003','S00001','O', 3, convert(date,'19-09-25',5));


select * from transactions;