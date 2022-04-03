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

