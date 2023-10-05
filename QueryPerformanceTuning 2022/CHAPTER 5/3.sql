--- statistics of data distribution 
/*
• Header: Information about the set of statistics you’re looking at
• Density Graph: A mathematical construct of the selectivity of the 
column or columns that make up the statistic
• Histogram: A statistical construct that shows how data is distributed  <==
across actual values within the first column of the statisti
*/

DROP TABLE IF EXISTS dbo.Test1;

DROP TABLE IF EXISTS #Nums;

GO
CREATE TABLE dbo.Test1
(
 C1 INT,
 C2 INT IDENTITY
);

INSERT INTO dbo.Test1
(
 C1
)
VALUES
(1 );
SELECT TOP 10000
 IDENTITY(INT, 1, 1) AS n
INTO #Nums
FROM master.dbo.syscolumns sc1,
 master.dbo.syscolumns sc2;

 GO
 INSERT INTO dbo.Test1
(
 C1
)
SELECT 2
FROM #Nums;

DROP TABLE #Nums;

CREATE NONCLUSTERED INDEX FirstIndex ON dbo.Test1 (C1);

SELECT s.name,
 s.auto_created,
 s.user_created
 FROM sys.stats AS s
WHERE object_id = OBJECT_ID('Test1');

select * from Test1 where c2 = 3

DBCC SHOW_STATISTICS(Test1, FirstIndex);

SELECT 1.0 / COUNT(DISTINCT C1)
FROM dbo.Test1;    --- Density 1.0/Count(DISTINCT C1)
DBCC SHOW_STATISTICS('Sales.SalesOrderDetail', 'IX_SalesOrderDetail_ProductID');

/*
• RANGE_HI_KEY: The top value of each range. There may or may 
not be values within the range. This value will be an actual value 
from the data in the column. If it’s a number column, like our INT 
in the example, it will be a number. If it’s a string, as we’ll show in 
later examples, it will have some value within the column shown as a 
string. For example, “London” from a City column.
• EQ_ROWS: The number of rows within the range at the point when 
the statistics were updated, or created, that match the RANGE_HI_
KEY value.
• RANGE_ROWS: The number of rows between the previous top 
value and the current top value, not counting either of those two 
boundary points.
• DISTINCT_RANGE_ROWS: The number of distinct values within 
the range. If all values are unique, then the RANGE_ROWS and 
DISTINCT_RANGE_ROWS will be equal.
• AVG_RANGE_ROWS: The number of rows equal to any potential 
key value within the range. Basically, RANGE_ROWS/DISTINCT_
RANGE_ROWS is the calculation to arrive this value.
*/


/* from query_optimizer_estimate_cardinality event we can get a couple imporatnt of information 
1) Card with is related to cardinality and this simulate number of rows estimated from operation
2) StatCollectionId from this we can get it's operator which results from card using find node
*/

-- auto creation of index didn't create compound key , so if you want you will need to create it manually
-- density is only for first column so we need when create index choose the most column can lead to decrease number of retrieve data

SELECT p.Name,
 p.Class
FROM Production.Product AS p
WHERE p.Color = 'Red'
 AND p.DaysToManufacture > 15;



 select s.auto_created,s.user_created,sc.column_id,c.name from sys.stats s join sys.stats_columns sc on s.object_id = sc.object_id and s.stats_id = sc.stats_id
 join sys.columns c on c.object_id = sc.object_id and c.column_id = sc.column_id
 where s.object_id = OBJECT_ID('Production.Product')
 CREATE INDEX IX_Test ON Sales.SalesOrderHeader (PurchaseOrderNumber);

 DBCC SHOW_STATISTICS('Sales.SalesOrderHeader', 'IX_Test')
 -- FILTEER EXPRESION IS NULL WE CAN ADD IT IF WE PUT CONTRASINT ON INDEX LIKE IS NOT NULL

 CREATE  INDEX IX_Test ON Sales.SalesOrderHeader (PurchaseOrderNumber)
 WHERE PurchaseOrderNumber IS NOT NULL
 WITH (DROP_EXISTING=ON)
  DBCC SHOW_STATISTICS('Sales.SalesOrderHeader', 'IX_Test')

  -- WE CAN FIGURE OUT NUMBER OF ROWS IN HEADER IS DECRESED FROM 41000 TO 3806 BASED ON FILTER EXPRESSION

  DROP INDEX Sales.SalesOrderHeader.IX_Test;

  BEGIN  TRY 
  PRINT 'GGF'
  SELECT 1/0
 END TRY   
 BEGIN CATCH
 PRINT ERROR_NUMBER()
 SELECT ERROR_MESSAGE()
 END CATCH 


 -- version of cardinality estimator can we control version if it greater than  120 so we use latest version if under 110 we use estimator of sql server 2012
 ALTER DATABASE AdventureWorks SET COMPATIBILITY_LEVEL = 110; -- problem with this pring back also many feature to it's old version not only cardincality estimator

--or 
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = ON;

-- or in query level 
SELECT p.Name,
 p.Class
FROM Production.Product AS p
WHERE p.Color = 'Red'
 AND p.DaysToManufacture > 15
OPTION (USE HINT ('FORCE_LEGACY_CARDINALITY_ESTIMATION'));

-- we can determine version from event query_optimizer_estimate_cardinality and this property called CardenalityEstimationModelVersion

/*
Disabling this setting at the database level overrides individual settings at lower 
levels. Auto Update Statistics Asynchronously requires that the Auto Update Statistics be 
on first. Then you can enable the asynchronous update, visible in Listing 5-32.
Listing 5-32. Turning on asynchronous statistics update
ALTER DATABASE AdventureWorks SET AUTO_UPDATE_STATISTICS_ASYNC ON;
*/

-- determmine auto update statictics 


EXEC sp_autostats
'HumanResources.Department',
'OFF',
[PK_Department_DepartmentID]

EXEC sp_autostats
'HumanResources.Department',
'OFF',
[AK_Department_Name]


EXEC sp_autostats 'HumanResources.Department';
select * from HumanResources.Department
EXEC sp_autostats
'HumanResources.Department',
'ON'

-- create statictics manually  , use sys.sp_createstats  execpt NTEXT, TEXT, 
--GEOMETRY, GEOGRAPHY, IMAGE or using  create statictics command AND UPDATE STATISTICS OR SP_UPDATESTAT

create statistics ST_GroupName on HumanResources.Department (GroupName) with SAMPLE 100 PERCENT ,AUTO_DROP = OFF--FULLSCAN -- OR SAMPLE 100 ROW OR PERCENT

UPDATE STATISTICS Customer (CustomerStats1) WITH AUTO_DROP = ON

EXEC sp_autostats
'HumanResources.Department'


UPDATE STATISTICS HumanResources.Department  -- UPDATE STATICTICS ON ALL STATS 

UPDATE STATISTICS HumanResources.Department ST_GroupName WITH FULLSCAN 

/*
If AUTO_UPDATE_STATISTICS is executed, it uses the persisted sampling percentage if available WITH SAMPLE 100 PERCENT PERSIST_SAMPLE_PERCENT = ON

*/
EXEC sp_autostats
'HumanResources.Department',
'OFF',
ST_GroupName

DROP STATISTICS HumanResources.Department.ST_GroupName

-- Three point to ensure effiencey of query 
/*
1) indexes is available on perdicate or join 
2)incase of missing indexes statictics available but index perefable 
3)Since outdated statistics are of no use and can even cause harm to 
your execution plans, it is important that the estimates used by the 
optimizer from the statistics are up to date.

 
*/
--remove plan from cache
 DBCC FREEPROCCACHE(@Planhandle);




