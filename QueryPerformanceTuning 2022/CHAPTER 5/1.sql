/*
Both Greater than 500 MIN(500+(0.2 * n), 
SQRT(1,000 * n))
In the calculation, “n” represents the number of rows in the table. You’re basically 
getting the MIN, or minimum, of the two calculations. Let’s assume a larger table with 5 
million rows. The first calculation results in a value of 1,000,500. The second calculation 
results in a value of 70,710. This would then mean that data modifications to only 70,710 
rows will result in a statistics update
*/


DROP TABLE IF EXISTS dbo.Test1;
GO
CREATE TABLE dbo.Test1(
 C1 INT,
 C2 INT IDENTITY
);


SELECT TOP 1500
 IDENTITY(INT, 1, 1) AS n
INTO #Nums
FROM master.dbo.syscolumns AS sC1,
 master.dbo.syscolumns AS sC2;

 INSERT INTO dbo.Test1
(
 C1
)
SELECT n
FROM #Nums;
DROP TABLE #Nums;	

CREATE NONCLUSTERED INDEX i1 ON dbo.Test1 (C1);


SELECT TOP 1500
 IDENTITY(INT, 1, 1) AS n
INTO #Nums
FROM master.dbo.syscolumns AS scl,
 master.dbo.syscolumns AS sC2;
INSERT INTO dbo.Test1
(
 C1
)
SELECT 2
FROM #Nums;
DROP TABLE #Nums;


GO

ALTER DATABASE AdventureWorks SET AUTO_UPDATE_STATISTICS OFF;

/*

Statistics Update Status Execution Plan Avg. Duration (ms) Number of Reads
Statistics Update Status |Execution Plan| Avg. Duration (ms)| Number of Reads
Up to date Figure            5-3                 1.6            9
Out of date Figure           5-5                 4.1            1,510
T
*/
GO

SELECT t.C1,
 t.C2
FROM dbo.Test1 AS t
WHERE t.C1 = 2;