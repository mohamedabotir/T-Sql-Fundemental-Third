use TSQL2012;
SELECT -- use * to explore other available attributes
request_session_id
AS spid,
resource_type
AS restype,
resource_database_id
AS dbid,
DB_NAME(resource_database_id) AS dbname,
resource_description
AS res,
resource_associated_entity_id AS resid,
request_mode
AS mode,
request_status
AS status
FROM sys.dm_tran_locks;