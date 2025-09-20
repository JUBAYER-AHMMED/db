use pubs;
go

------task : 1-------
--1
select name from sys.tables;
go

--2
--(i)
select * from authors;
--(ii)
select au_fname, city from authors;
--(iii)
select * from authors where city = 'Berkeley';

select *  from authors where au_lname = 'White' and state = 'CA';


--Task: 1
select  name from sys.tables;

select title from titles where ytd_sales > 8000 ;

--Task: 2 ***
select title from titles where royalty between 12 and 24;
--or
select title from titles where royalty >= 12 and royalty <= 24;


--3
select * from titles;
select title,price from titles order by price asc;
select title,price from titles order by price desc;

--4: Aggregate functions:
--(max):
select max(price) from titles;
--(min):
select min(price) from titles;
--(avg):
select avg(price) from titles;
--(sum):
select sum(price) from titles;
--(count):
select count(price) from titles;

--*** aggregate function avoids the null values ***--
--5
select * from titles;
select type, avg(price) as avg_price from titles group by type;

--6
select type, avg(price) as avg_price from titles group by type having avg(price) > 15;

--task:3
select type, avg(price) as avg_price , sum(ytd_sales) as Total_Yearly_sales from titles group by type;


--7
select * from authors;
select "Name"=substring(au_fname,1,1) + '.' + au_lname,phone from authors;