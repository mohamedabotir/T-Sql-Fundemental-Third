use iti;

declare @max_crs_id  as int = (select max(dbo.Course.Crs_Id) from dbo.Course);	
select @max_crs_id
select * from dbo.Course where Crs_Id = @max_crs_id;

--in single query 
select * from dbo.Course where Crs_Id = (select max(Crs_Id) from dbo.Course);

-- we can't use equality if expected inner query multiple values we can use any ,some , all ,in for multivalued
select Crs_Id from dbo.Course where Crs_Name like N'%P%';
select * from dbo.Ins_Course where Crs_Id in (select Crs_Id from dbo.Course where Crs_Name like N'%P%');

--correlated subquery subquery depend on outer query 
select st_id,St_Address,Dept_Id from  dbo.Student as s where s.Dept_Id in (select Dept_Id from dbo.Department as b where b.Dept_Location =s.St_Address)
select * from dbo.Student

--exists predicate return true if subquery returns any row
--find previous id
select a.Crs_Id , (select max(p.Crs_Id) from dbo.Course as p  where p.Crs_Id < a.Crs_Id) as previous_crsId from dbo.Course as a

