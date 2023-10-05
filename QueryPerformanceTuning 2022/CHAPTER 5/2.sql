/*
ALTER DATABASE AdventureWorks SET AUTO_CREATE_STATISTICS ON;
*/
DROP TABLE IF EXISTS dbo.Test1;
GO
CREATE TABLE dbo.Test1
(
 Test1_C1 INT IDENTITY,
 Test1_C2 INT
);

INSERT INTO dbo.Test1
(
 Test1_C2
)
VALUES
(1 );


SELECT TOP 10000
 IDENTITY(INT, 1, 1) AS n
INTO #Nums
FROM master.dbo.syscolumns AS scl,
 master.dbo.syscolumns AS sC2;


 INSERT INTO dbo.Test1
(
 Test1_C2
)
SELECT 2
FROM #Nums;

GO
CREATE CLUSTERED INDEX i1 ON dbo.Test1 (Test1_C1);

SELECT DATABASEPROPERTYEX('AdventureWorks2022', 'IsAutoCreateStatistics'); -- 1 MEAN ON

 
GO
 IF
(
 SELECT OBJECT_ID('dbo.Test2')
) IS NOT NULL
 DROP TABLE dbo.Test2;
GO
CREATE TABLE dbo.Test2
(
 Test2_C1 INT IDENTITY,
 Test2_C2 INT
);
INSERT INTO dbo.Test2
(
 Test2_C2
)
VALUES
(2 );
INSERT INTO dbo.Test2
(
 Test2_C2
)
SELECT 1
FROM #Nums;

CREATE CLUSTERED INDEX il ON dbo.Test2 (Test2_C1);

GO


GO
SELECT t1.Test1_C2,
 t2.Test2_C2
FROM dbo.Test2 AS t2
 JOIN dbo.Test1 AS t1
 ON t1.Test1_C2 = t2.Test2_C2
WHERE t1.Test1_C2 = 1;


GO
SELECT s.name,
 s.auto_created,
 s.user_created
 FROM sys.stats AS s
WHERE object_id = OBJECT_ID('Test1');

GO
-- TEST WITHOUT DATABASE PROPERTY INDEX 
ALTER DATABASE AdventureWorks SET AUTO_CREATE_STATISTICS OFF;