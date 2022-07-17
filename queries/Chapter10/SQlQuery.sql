use TSQL2012;
DECLARE @num as int =15;
select @num;
set @num=10;
select @num;

--select * from Sales.Customers;
set @num = (select postalcode from Sales.Customers where custid = 1)
SELECT @num;

EXEC sp_help 'Sales.Customers';
