use pubs;
select name from sys.tables;

--2
alter proc sp_showTitleAndAuthor @title_id char(6)
as 
begin
  select 'Name' =  substring(au_fname,1,1) + '.' + au_lname from authors join titleauthor on authors.au_id = titleauthor.au_id where titleauthor.title_id = @title_id;
end

select * from titleauthor;
exec sp_help 'titles';
exec sp_showTitleAndAuthor 'PS3333';

--1
create proc sp_showTitleAndAuthor2 
as
begin
  select au_fname + ' ' + au_lname as Author_Name from authors where au_id in (select au_id from titleauthor where title_id = 'BU1032');
end
exec sp_showTitleAndAuthor2;

--3
create proc sp_updatePrice @titleid char(6)
as 
begin
   declare @price money
   select @price = price from titles where titles.title_id = @titleid
   set @price = @price + @price*0.1;
   if @price <=20
    update titles 
     set price = @price where title_id = @titleid;
end

exec sp_updatePrice 'BU7832';
select price from titles where title_id = 'BU7832';


--task1:
select * from CandS;
select * from Item;

insert into Item
(item_id,item_name,item_category,item_price,item_qoh,item_last_sold)
values
('P00004','Beef', 'Food',200,150,'2025-09-19');
exec sp_help 'Item';

---------------------------------------------
--***********
---------------------------------------------
create proc sp_task1 @category varchar(10)
as 
begin
   select item_category as Category,
          sum(item_qoh) as Total_Quantity,
          avg(item_price) as 'Average Price' 
          from Item 
          where item_category = @category
          group by item_category ;
end

exec sp_task1 'Food'

---task:3
exec sp_help 'Item'
create proc sp_avgInc @category varchar(10), @desired_avg_price float(12)
as begin
  
  declare @current_avg_price float(12);
  select @current_avg_price = avg(item_price) from Item 
  where item_category = @category;

  while @current_avg_price < @desired_avg_price
  begin
    update Item
    set item_price = item_price + item_price*0.1 
    where item_category = @category; 
    select @current_avg_price = avg(item_price) from Item 
    where item_category = @category;
  end

  select @category as Category, @current_avg_price as 'Final Avg Price';
end

exec sp_avgInc 'Food', 400;

--task:2
exec sp_help 'Item';
alter proc sp_cheaper @category varchar(10), @price float(12)
as
begin
  select * from Item where item_price < @price and item_category = @category;
end

exec sp_cheaper 'Food', 500;
