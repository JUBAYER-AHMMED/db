create trigger Tr
on Item after insert
as begin
  print 'Data Inserted in the Item table.';
end

select * from Item;

insert into Item
(item_id,item_name,item_category,item_price,item_qoh)
values('P00005','TV','Electrical',50000,15);

--2
select * from transactions;
exec sp_help 'transactions';
create trigger tr2
on transactions for insert
as begin
  declare @item_id char(6), @quantity int, @tran_type char(1)
  select @item_id = item_id , @quantity = tran_quantity, @tran_type = tran_type from inserted;

  if @tran_type = 'S'
  update Item
  set item_qoh = item_qoh - @quantity where item_id = @item_id;
  else
  update Item
  set item_qoh = item_qoh + @quantity where item_id = @item_id;
end

select * from Item;
select * from transactions;
insert into transactions
(tran_id,item_id,cus_id,tran_type,tran_quantity)
values('T000000007','P00001','C00003','S',5);

select * from CandS;
select * from Item;
exec sp_help 'Item';
create trigger Tr3
on transactions for insert
as begin
  declare @item_id char(6), @quantity int, 
  @tran_type char(1), @item_price float, @cus_id char(6);
  select @item_id = item_id , @quantity = tran_quantity,
  @tran_type = tran_type, @cus_id = cus_id from inserted;
  
  select @item_price = item_price from Item where item_id = @item_id;
  declare @tran_amount float;
  select @tran_amount = @item_price * @quantity;

  if @tran_type = 'S'
    update CandS
    set sales_amnt = sales_amnt + @tran_amount where cus_id = @cus_id;
  else
    update CandS
    set proc_amnt = proc_amnt + @tran_amount where cus_id = @cus_id;
end


--alternative: better for multiple rows.
CREATE TRIGGER Tr3
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update sales amount for sale transactions
    UPDATE cs
    SET cs.sales_amnt = cs.sales_amnt + (i.tran_quantity * it.item_price)
    FROM CandS cs
    INNER JOIN inserted i ON cs.cus_id = i.cus_id
    INNER JOIN Item it ON i.item_id = it.item_id
    WHERE i.tran_type = 'S';

    -- Update procurement amount for purchase transactions
    UPDATE cs
    SET cs.proc_amnt = cs.proc_amnt + (i.tran_quantity * it.item_price)
    FROM CandS cs
    INNER JOIN inserted i ON cs.cus_id = i.cus_id
    INNER JOIN Item it ON i.item_id = it.item_id
    WHERE i.tran_type = 'O';
END;
GO
