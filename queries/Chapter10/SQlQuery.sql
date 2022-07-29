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

--exec execute string or unicode  be careful due to  sql injection

/*
declare @sql as varchar(100);
set @sql = 'PRINT ''hello,world!''';
exec(@sql);

*/

--sp_executesql more secure 
/* The best way to efficiently reuse query execution 
plans is to use stored procedures with parameters. 
*/
declare @sql1 as nvarchar(100);
SET @sql1 = N'SELECT orderid, custid, empid, orderdate FROM Sales.Orders WHERE orderid = @orderid;';
EXEC sp_executesql
 @stmt = @sql1,
 @params = N'@orderid AS INT' ,
 @orderid = 10248

 --pivot

 select * from 
 (select shipperid , year(shippeddate) as shipyear ,freight from sales.Orders)as d
 pivot (sum(freight) for shipyear in([2006],[2008],[2007])) as p;


 /*
 using cursor to get all years dynamics
 */
 DECLARE
 @sql AS NVARCHAR(1000),
 @orderyear AS INT,
 @first AS INT;
DECLARE C CURSOR FAST_FORWARD FOR
 SELECT DISTINCT(YEAR(orderdate)) AS orderyear
 FROM Sales.Orders
 ORDER BY orderyear;
SET @first = 1;
SET @sql = N'SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
 FROM Sales.Orders) AS D
 PIVOT(SUM(freight) FOR orderyear IN(';
OPEN C;
FETCH NEXT FROM C INTO @orderyear;
WHILE @@fetch_status = 0
BEGIN
 IF @first = 0
 SET @sql = @sql + N','
 ELSE
 SET @first = 0;
 SET @sql = @sql + QUOTENAME(@orderyear);
 FETCH NEXT FROM C INTO @orderyear;
END
CLOSE C;
DEALLOCATE C;
SET @sql = @sql + N')) AS P;';
EXEC sp_executesql @stmt = @sql;
--stored procedure
/*
Stored procedures encapsulate logic. If you need to change the implementation of a 
stored procedure, you can apply the change in one place in the database and the procedure 
will be altered for all users of the procedure.
*/


/*
Stored procedures give you better control of security. You can grant a user permissions 
to execute the procedure without granting the user direct permissions to perform the underlying activities. For example, suppose that you want to allow certain users to delete a customer 
from the database, but you don’t want to grant them direct permissions to delete rows from 
the Customers table. You want to ensure that requests to delete a customer are validated—for 
example, by checking whether the customer has open orders or open debts—and you may 
also want to audit the requests. By not granting direct permissions to delete rows from the 
Customers table but instead granting permissions to execute a procedure that handles the 
task, you ensure that all the required validations and auditing always take place. In addition, 
stored procedures can help prevent SQL injection, especially when they replace ad-hoc SQL 
from the client with parameters.
*/
go;
CREATE PROC Sales.GetCustomerOrders
 @custid AS INT,
 @fromdate AS DATETIME = '19000101',
 @todate AS DATETIME = '99991231',
 @numrows AS INT OUTPUT
AS
SET NOCOUNT ON;
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
 AND orderdate >= @fromdate
 AND orderdate < @todate;
SET @numrows = @@rowcount;
GO

DECLARE @rc AS INT;
EXEC Sales.GetCustomerOrders
 @custid = 1, 
  @fromdate = '20070101',
 @todate = '20080101',
 @numrows = @rc OUTPUT;
 
 select @rc

 CREATE TABLE dbo.T2
(
 keycol INT NOT NULL PRIMARY KEY,
 datacol VARCHAR(10) NOT NULL
);
CREATE TABLE dbo.T2_Audit
(
 audit_lsn INT NOT NULL IDENTITY PRIMARY KEY,
 dt DATETIME NOT NULL DEFAULT(SYSDATETIME()),
 login_name sysname NOT NULL DEFAULT(ORIGINAL_LOGIN()),
 keycol INT NOT NULL,
 datacol VARCHAR(10) NOT NULL
);
go;
create trigger trg_T2_audit on dbo.t2 after insert
as 
set nocount on
insert into dbo.T2_Audit(keycol,datacol)
select  keycol, datacol from inserted;
go;

INSERT INTO dbo.T2(keycol, datacol) VALUES(10, 'a');
INSERT INTO dbo.T2(keycol, datacol) VALUES(30, 'x');
INSERT INTO dbo.T2(keycol, datacol) VALUES(20, 'g');


select * from dbo.T2_Audit;


--ddl trigger

CREATE TABLE dbo.AuditDDLEvents
(
 audit_lsn INT NOT NULL IDENTITY,
 posttime DATETIME NOT NULL,
 eventtype sysname NOT NULL,
 loginname sysname NOT NULL,
 schemaname sysname NOT NULL,
 objectname sysname NOT NULL,
 targetobjectname sysname NULL,
 eventdata XML NOT NULL,
 CONSTRAINT PK_AuditDDLEvents PRIMARY KEY(audit_lsn)
);
go;
CREATE TRIGGER trg_audit_ddl_events
 ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
SET NOCOUNT ON;
DECLARE @eventdata AS XML = eventdata();
INSERT INTO dbo.AuditDDLEvents(
 posttime, eventtype, loginname, schemaname, 
 objectname, targetobjectname, eventdata)
 VALUES(
 @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]', 'VARCHAR(23)'),
 @eventdata.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname'),
 @eventdata.value('(/EVENT_INSTANCE/LoginName)[1]', 'sysname'),
 @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
 @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
 @eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
 @eventdata);
GO

--error handling
begin try
print 10/0
end try
begin catch
print N'Divide By Zero'
print error_message()
print error_number()
if ERROR_NUMBER() = 8134
 throw
end catch
