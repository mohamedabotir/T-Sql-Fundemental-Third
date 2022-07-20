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


IF YEAR(SYSDATETIME()) <> YEAR(DATEADD(day, 1, SYSDATETIME()))
 PRINT 'Today is the last day of the year.';
ELSE
 IF MONTH(SYSDATETIME()) <> MONTH(DATEADD(day, 1, SYSDATETIME()))
 PRINT 'Today is the last day of the month but not the last day of the year.';
 ELSE
 PRINT 'Today is not the last day of the month.';

 --while
 DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
 PRINT @i;
 SET @i = @i + 1;
END;
go;
declare @Result table(
 custid INT,
 ordermonth DATETIME,
 prvcustid   INT
 PRIMARY KEY(custid, ordermonth)
);

DECLARE
 @custid AS INT,
 @prvcustid AS INT,
 @ordermonth DATETIME,
 @qty AS INT,
 @runqty AS INT;

 declare C Cursor fast_forward for

 select custid,orderdate from Sales.Orders order by custid,orderdate;	

 open C;
 Fetch next from C Into @custid ,@ordermonth;

 select @custid,@ordermonth
 set @prvcustid = @custid;
 while @@FETCH_STATUS=0
 begin
 insert into @Result values(@custid,@ordermonth,@prvcustid);
 fetch next from C into @custid,@ordermonth;
 end;
 close C;
 deallocate C;
 select * from @Result;
 go;
 /* better performance with set manipulation
 SELECT custid, ordermonth, qty,
 SUM(qty) OVER(PARTITION BY custid
 ORDER BY ordermonth
 ROWS UNBOUNDED PRECEDING) AS runqty
FROM Sales.CustOrders
ORDER BY custid, ordermonth;
 */



 --three kinds of temperory table  local temporary tables, global temporary tables, and table variables.
 IF OBJECT_ID('tempdb.dbo.#MyOrderTotalsByYear') IS NOT NULL
 DROP TABLE dbo.#MyOrderTotalsByYear;
GO
CREATE TABLE #MyOrderTotalsByYear
(
 orderyear INT NOT NULL PRIMARY KEY,
 qty INT NOT NULL
);
select OBJECT_ID('tempdb.dbo.#MyOrderTotalsByYear')

select * from #MyOrderTotalsByYear;
--global 
/*

When you create a global temporary table, it is visible to all other sessions. Global temporary tables 
are destroyed automatically by SQL Server when the creating session disconnects and there are no 
active references to the table. You create a global temporary table by naming it with two number 
signs as a prefix, such as ##T1

*/

CREATE TABLE dbo.##Globals
(
 id sysname NOT NULL PRIMARY KEY,
 val SQL_VARIANT NOT NULL
);
select * from ##Globals;


--variable is like local but more limit is for batch or subsequence 
--better to use in few rows and otherwise use local
DECLARE @MyOrderTotalsByYear TABLE
(
 orderyear INT NOT NULL PRIMARY KEY,
 qty INT NOT NULL
);

--table type create type of table can be used in declare table variable or parameters of stored procedure
CREATE TYPE dbo.OrderTotalsByYear AS TABLE
(
 orderyear INT NOT NULL PRIMARY KEY,
 qty INT NOT NULL
);

DECLARE @MyOrderTotalsByYear1 AS dbo.OrderTotalsByYear;
