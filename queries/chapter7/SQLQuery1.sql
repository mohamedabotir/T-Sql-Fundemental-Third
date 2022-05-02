use iti;
select Dept_Id  ,Salary,Ins_Name, SUM(Salary) over(partition by Dept_Id order by Ins_Name desc ROWS BETWEEN UNBOUNDED PRECEDING
 AND CURRENT ROW) from Instructor as ins



select Dept_Id  ,Salary,Ins_Name, SUM(Salary) over(partition by Dept_Id order by Ins_Name desc) from Instructor as ins


select Dept_Id , SUM(Salary) from Instructor group by Dept_Id


select Dept_Id  ,Salary,Ins_Name ,ROW_NUMBER() over(partition by Dept_Id order by Ins_Id) from Instructor;

select Dept_Id  ,Salary,Ins_Name ,Rank() over(partition by Ins_Name order by Ins_Id) from Instructor;

--prevoius value
select Dept_Id  ,Salary,Ins_Name ,Lag(Salary) over(partition by Dept_Id order by Ins_Id) from Instructor;
--next value
select Dept_Id  ,Salary,Ins_Name ,LEAD(Salary) over(partition by Dept_Id order by Ins_Id) from Instructor;

select Dept_Id  ,Salary,Ins_Name ,First_Value(Salary) over(partition by Dept_Id order by Ins_Id) from Instructor;

select Dept_Id  ,Salary,Ins_Name ,Last_Value(Salary) over(order by Ins_Id rows between unbounded preceding and current row) from Instructor;

select Dept_Id  ,Salary,Ins_Name ,sum(Salary) over() from Instructor;

select Dept_Id,Ins_Name,
case Ins_Name 
when 'Ahmed' then 'Ahmed Here!'
else 'no Course'
end
from Instructor 

select Dept_Id,Ins_Degree ,SUM(Salary) from Instructor group by Dept_Id,Ins_Degree

select Dept_Id ,Master,PHD from (select Ins_Id,Dept_Id,Salary,Ins_Degree from Instructor)
as D pivot(sum(Salary) for Ins_Degree IN (Master,PHD)) AS P;

go;
select Ins_Id,Dept_Id,Salary,Ins_Degree from Instructor unpivot(Salary for Ins_Degree in (Master,PHD));


--grouping sets

select Ins_Name,sum(Salary),Dept_Id from Instructor Group by 
Grouping Sets (
(Dept_Id,Ins_Name)
)


select Ins_Name,sum(Salary),Dept_Id from Instructor Group by 
cube(
(Dept_Id,Ins_Name)
)