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
---user percent with top mean percentage of returned row 
select   top(10) percent   Course.Crs_Duration from Course order by Crs_Duration desc; 
---with ties used with top to return values has the same sort value
select   top(5)with ties Course.Crs_Duration , Course.Crs_Id  from Course  order by Crs_Duration desc; 

--- used only by order by 
---fetch-offset fetch (number of skip) rows offset next (number of row will filter) rows only
select  Course.Crs_Duration  from Course order by Crs_Duration desc offset 3 row fetch next 3 row only;

---can write like  that also
select  Course.Crs_Duration  from Course order by Crs_Duration desc offset 3 rows fetch first 3 rows only;
---************window function*****************---
select Course.Top_Id,Course.Crs_Duration ,row_number() over(partition by Course.top_id order by course.Crs_Id) from Course 

---predicates supported by T-SQL include IN, BETWEEN, and LIKE.
---supported operators =, >, <, >=, <=, <>, !=, !>, !<
select * from course;
/*case when */
select Course.Top_Id, Course.Crs_Id ,
case Course.Crs_Id
when 100 then 'html'
when 200 then 'c Programming'
else 'no course'
end
from Course

-- null is undefined value so can't determine with value so if null = null will return null
select * from Course where Course.Crs_Name like  N'c%'