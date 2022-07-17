use TSQL2012;
DECLARE @num as int =15;
select @num;
set @num=10;
select @num;

--select * from Sales.Customers;
set @num = (select postalcode from Sales.Customers where custid = 1)
SELECT @num;

EXEC sp_help 'Sales.Customers';

go;--end of batch
DECLARE @num as int= 50;

PRINT @num

go;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT IDENTITY);
SET NOCOUNT ON;
insert into T1 DEFAULT VALUEs;
go 100;
select * from Nums;