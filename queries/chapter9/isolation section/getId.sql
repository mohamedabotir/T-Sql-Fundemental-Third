use TSQL2012;
declare @numsId as Int;
-- Insert a new order into the Sales.Orders table
 INSERT INTO Sales.Orders
 (custid, empid, orderdate, requireddate, shippeddate, 
 shipperid, freight, shipname, shipaddress, shipcity,
 shippostalcode, shipcountry)
 VALUES
 (85, 5, '20090212', '20090301', '20090216',
 3, 32.38, N'Ship to 85-B', N'6789 rue de l''Abbaye', N'Reims',
 N'10345', N'France');
set @numsId = SCOPE_IDENTITY()
select @numsId;




