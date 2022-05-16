use TSQL2012;

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders
(
 orderid INT NOT NULL
 CONSTRAINT PK_Orders PRIMARY KEY,
 orderdate DATE NOT NULL
 CONSTRAINT DFT_orderdate DEFAULT(SYSDATETIME()),
 empid INT NOT NULL,
 custid VARCHAR(10) NOT NULL
)
INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
 SELECT orderid, orderdate, empid, custid
 FROM Sales.Orders
 WHERE shipcountry = 'UK';



 select * from dbo.Orders;

 INSERT INTO dbo.Orders
 (orderid, orderdate, empid, custid)
VALUES
 (10003, '20090213', 4, 'B'),
 (10004, '20090214', 1, 'A'),
 (10005, '20090213', 1, 'C'),
 (10006, '20090215', 3, 'C');


 go;
 create function selectEmpid 
 (@is_id as int ) returns table 
 as return 
 select empid,orderid,orderdate from dbo.Orders where empid = @is_id;
 go;

 --stored procedure
  create proc proc_sales @empi_id as int 
  as select * from dbo.Orders where empid = @empi_id;



  INSERT INTO dbo.Orders
 (orderid, orderdate, empid, custid)
VALUES
 (10014, '20090213', 3, 'B')
 go;
  exec proc_sales @empi_id = 3;

  create table temp (
 orderid INT NOT NULL
 CONSTRAINT PK_Orders1 PRIMARY KEY,
 orderdate DATE NOT NULL
 CONSTRAINT DFT_orderdate1 DEFAULT(SYSDATETIME()),
 empid INT NOT NULL,
 custid VARCHAR(10) NOT NULL
)
if object_id('temp') is not null drop table temp
-- create table called temp then insert in it all data in sales.orders 
-- must temp didn't created before
select * into temp from Sales.Orders

select * from temp;
select * from dbo.orders

--insert data to execting table from file
BULK INSERT dbo.Orders FROM 'c:\temp\orders.txt'
 WITH 
 (
 DATAFILETYPE = 'char',
 FIELDTERMINATOR = ',',
 ROWTERMINATOR = '\n'
 );

 /*Remember that both @@identity and SCOPE_IDENTITY return the last identity value produced by 
the current session
*/
 SELECT
 SCOPE_IDENTITY() AS [SCOPE_IDENTITY],
 @@identity AS [@@identity],
 IDENT_CURRENT('dbo.Orders') AS [IDENT_CURRENT];
 
 
 select IDENT_CURRENT('dbo.Orders');

 --remember DBCC CHECKIDENT 



 /* sequence ALTER SEQUENCE command (MINVAL <val>, MAXVAL <val>
 , RESTART WITH <val>, INCREMENT BY <val>, CYCLE | NO CYCLE, 
or CACHE <val> | NO CACHE).
*/
 create sequence incr as int 
 minvalue 5;
 select next value for incr;

 --The advantage that TRUNCATE has over DELETE is that the former is minimally logged,
 --truncate tablename delete all table data
 --delete based on join

DELETE FROM O 
FROM dbo.Orders AS O 
 JOIN dbo.Customers AS C 
 ON O.custid = C.custid 
WHERE C.country = N'USA';

--update based on join
UPDATE OD
 SET discount += 0.05
FROM dbo.OrderDetails AS OD
 JOIN dbo.Orders AS O
 ON OD.orderid = O.orderid
WHERE O.custid = 1;