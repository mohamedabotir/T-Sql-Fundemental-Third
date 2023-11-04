select * from sys.database_query_store_options
/*
capturing process
after storing plan in plancache asynchronous processes will invoke
 - copy plan to temperory storage 
 - copy plan to query store
 - after query complete execution another process invoked to store runtime metrics such as duration, reads, wait statistics, and more are written to a 
separate memory space through
 - then after interval which is by default 60 minutes this collected data is aggregated and summerized and persists
 this run time metric store in main hard drive so this information restored with database (Statistics Collection Interval )
*/

-- default writing information into query store 15 minutes and before this period the information exists only in memmory


--ALTER DATABASE AdventureWorks SET QUERY_STORE CLEAR;
--EXEC sys.sp_query_store_remove_query @query_id = @QueryId;
--EXEC sys.sp_query_store_remove_plan @plan_id = @PlanID;
--EXEC sys.sp_query_store_flush_db;
--ALTER DATABASE AdventureWorks SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 200);

-- to store portion of  optimization process plan should be full optimization process

/*
captured mode 
- all capture all queries
- none capture still enabled so you can force plan for plan exising inside store by query store stop captureing new queris
- auto capture query still open but capturing depend on custome filteratons run three times or longer than on seconds 

*/ 

EXEC sys.sp_query_store_force_plan 1, 1;
EXEC sys.sp_query_store_set_hints 550, N'OPTION(OPTIMIZE FOR UNKOWN)'; -- get rid of parameter sniffing
EXEC sp_query_store_clear_hints @query_id = 550;





-- oprimize force planing to store portion of optimization process
ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZED_PLAN_FORCING = OFF;
-- or in query level using DISABLE_OPTIMIZED_PLAN_FORCING



alter database AdventureWorks2022 set query_store =on
alter database AdventureWorks2022 set query_store (max_storage_size_mb = 200)





 WITH SalesByProduct AS (
  SELECT p.ProductID, p.Name, pc.Name AS Category, SUM(sd.LineTotal) AS SalesAmount,
  RANK() OVER (PARTITION BY pc.ProductCategoryID ORDER BY SUM(sd.LineTotal) DESC) AS Rank
  FROM Production.Product p
  JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
  JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
  JOIN Sales.SalesOrderDetail sd ON p.ProductID = sd.ProductID
  GROUP BY p.ProductID, p.Name, pc.ProductCategoryID, pc.Name
)
SELECT sbp.ProductID, sbp.Name, sbp.Category, sbp.SalesAmount
FROM SalesByProduct sbp
WHERE sbp.Rank <= 10
ORDER BY sbp.Category, sbp.Rank;



 select qrs.* from  sys.query_store_query qs inner join 
                               sys.query_store_query_text qst
							   on qs.query_text_id = qst.query_text_id
							   inner join sys.query_store_plan qp on qs.query_id = qp.query_id
							   inner join sys.query_store_wait_stats qws on   qp.plan_id = qws.plan_id
							   inner join sys.query_store_runtime_stats qrs on qrs.plan_id = qp.plan_id
							   inner join sys.query_store_runtime_stats_interval qrsi on qrsi.runtime_stats_interval_id = qrs.runtime_stats_interval_id

							   select *  from sys.query_store_plan;

									  -- select * from  sys.query_store_runtime_stats_interval 