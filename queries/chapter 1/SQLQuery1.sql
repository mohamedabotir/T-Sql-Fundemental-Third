use iti;
/*
1-from
2-where
3-group by
4-having
5-select
6-orderby
*/
/*
delimit identifier using [] or ""
*/
select  dbo.Course.Top_Id ,dbo.Course.Crs_Duration ,count(Top_Id) as [counts top] from dbo.Course group by dbo.Course.Top_Id,dbo.Course.Crs_Duration order by Top_Id asc;
---select * from Course;
--- if you compute thing in side the same syntax is not repeted it computed once like select count(Top_Id) as count from course where count(Top_Id)
---a set (or multiset, if it has duplicates)

select  Course.Crs_Duration from Course order by Crs_Duration; 