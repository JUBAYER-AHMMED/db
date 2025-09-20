use pubs;
select title, 
substring(au_fname,1,1) + '.' + au_lname as 'Name', 
pub_name 
from titles 
join titleauthor on  titles.title_id= titleauthor.title_id
join authors on authors.au_id = titleauthor.au_id
join publishers on publishers.pub_id = titles.pub_id;

select * from titles;
select * from authors;
select * from titleauthor;
select * from sales where title_id = 'BU1032';

--2:
select title,
       sum(qty) as TotalQuantitySold
       from titles join sales
       on titles.title_id = sales.title_id
       group by title
       having sum(qty) > 40
       order by TotalQuantitySold asc;

