use iti;


declare @min as int = 15;

select * from (select Ins_Id,Ins_Name,Dept_Id from Instructor) as ctes;

select dept_id,count(name) as count from (select Ins_Id,Dept_Id as dept_id ,Ins_Name as name from Instructor) as ctes group by dept_id;

select dept_id,count(name) as count from (select Ins_Id,Dept_Id as dept_id ,Ins_Name as name from Instructor) as ctes group by dept_id;
-- common table expressions(CTEs


 
with uct as
(
select Ins_Id,Dept_Id as dept_id ,Ins_Name as name from Instructor
)
select dept_id,count(name) as count from uct as ctes group by dept_id;



-- multiple ctes
with uct2 as
(
select Ins_Id,Dept_Id as dept_id ,Ins_Name as name from Instructor where Dept_Id>20
),
uct3 as
(
select Ins_Id,Dept_Id as dept_id from uct2
)

select dept_id,count(name) as count from uct2 as ctes group by dept_id

-- views like ctes but reusable go is separator only not tsql order by 
--not allowed to views but allow for three state only TOP, OFFSET-FETCH, or FOR XML

if OBJECT_ID('inst_view') is not null
drop view inst_view
go
create view inst_view as select Ins_Id ,Ins_Name from Instructor;
go
SELECT OBJECT_DEFINITION(OBJECT_ID('inst_view')); -- will return statement of creation of view because encryption option is null
go
alter view inst_view with encryption 
as 
select Ins_Id ,Ins_Name from Instructor;
go;
--schemabinding option this option restrict from drop table view  depend on it and restrict view from alter column

--create view inst_view_  with schemabinding as select Ins_Id ,Ins_Name from Instructor;


--with check option is useful when prevent insert for specific value 

alter view inst_view with schemabinding 
as 
select Ins_Id ,Ins_Name,Ins_Degree,Salary,Dept_Id from dbo.Instructor where Ins_Degree = N'Master' with check option; 
go;

insert into inst_view (Ins_Id ,Ins_Name,Ins_Degree,Salary,Dept_Id) values(16,N'ramez','PHD',4500,10);


--tfs(table valued function)
go;
create function getInsId
(@is_id as int) returns table
as return 
select Ins_Id,Ins_Name,Ins_Degree from Instructor where Ins_Id = @is_id;
go;

select  Ins_Name ,Ins_Degree,Ins_Id from getInsId(16);
--When you’re done, run the following code for cleanup.
--IF OBJECT_ID('dbo.GetCustOrders') IS NOT NULL
--DROP FUNCTION dbo.GetCustOrders;

--apply operator
select Ins_Id,Ins_Name,Ins_Degree from Instructor as i 
Outer Apply 
(select Ins_Id,Crs_Id from Ins_Course as c where c.Ins_Id = i.Ins_Id order by Ins_Id offset 0 rows fetch first 3 rows only)