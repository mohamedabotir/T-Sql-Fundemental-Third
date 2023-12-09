
/*
query split into two categoreis 
- adhoc :query depend on parameter but hard coded in query each change in value lead to generate new execution plan
- prepared : query depend on variable values like local parameter
*/
select refcounts,usecounts,size_in_bytes,cacheobjtype,objtype,plan_handle,text from sys.dm_exec_cached_plans cp
cross apply sys.dm_exec_sql_text(cp.plan_handle)



select  * from Sales.SalesOrderHeader  sh inner join sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
where CustomerID = 29734


dbcc freeproccache (0x06000100962E9C11A0E28FB91402000001000000000000000000000000000000000000000000000000000000)


-- we can optimize with enabling setting called optimize for ad hoc workload 
-- this lead to store plan stub  which is less than query plan in size and when called second time complete plan is stored in cache plan
-- enable oprimization option
exec sys.sp_configure 'show advanced option','1'
reconfigure
exec sys.sp_configure 'optimize for ad hoc workloads','1'
reconfigure

select  * from Sales.SalesOrderHeader  sh inner join sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
where CustomerID = 29734

select refcounts,usecounts,size_in_bytes,cacheobjtype,objtype,plan_handle,text from sys.dm_exec_cached_plans cp
cross apply sys.dm_exec_sql_text(cp.plan_handle)

-- reset it to disabled
exec sys.sp_configure 'optimize for ad hoc workloads','0'
reconfigure
exec sys.sp_configure 'show advanced option','0'
reconfigure

-- prepared 
dbcc freeproccache

select  * from Sales.SalesOrderHeader  sh 
inner join sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
where CustomerID = 29734
-- the difference between below is that query optimizer mark first query which depend on revisionNumber as ad hoc , second prepared may be beacuse  of this column is unique
select  * from Sales.SalesOrderHeader  sh 
where sh.RevisionNumber=8

select  * from Sales.SalesOrderHeader  sh 
where sh.rowguid='79B65321-39CA-4115-9CBA-8FE0903E12E6'

select * from Person.Address as a  where a.AddressID=42

-- below query will use he same plan  because of both use the same type of paramererized query
select * from Person.Address as a  where a.AddressID between 41 and 42
select * from Person.Address as a  where a.AddressID <= 42 and  a.AddressID >=41


select refcounts,usecounts,size_in_bytes,cacheobjtype,objtype,plan_handle,text from sys.dm_exec_cached_plans cp
cross apply sys.dm_exec_sql_text(cp.plan_handle)






