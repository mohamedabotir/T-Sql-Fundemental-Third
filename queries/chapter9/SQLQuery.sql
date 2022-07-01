use TSQL2012;

BEGIN TRANSACTION
DECLARE @identity as INT;
--SELECT @identity;
INSERT into Sales.Orders 
(custid, empid, orderdate, requireddate, shippeddate,
shipperid, freight, shipname, shipaddress, shipcity,
shippostalcode, shipcountry)
VALUES
(85, 5, '20090212', '20090301', '20090216',
3, 32.38, N'Ship to 85-B', N'6789 rue de l''Abbaye', N'Reims',
N'10345', N'France');
set @identity = SCOPE_IDENTITY();
SELECT @identity;

COMMIT TRANSACTION