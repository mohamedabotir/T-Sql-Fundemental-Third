use iti;
--union with all multiset repeat but without is set elemenate duplication
select Ins_Id from Instructor 
union  
select Ins_Id from Ins_Course;


select Ins_Id from Instructor 
INTERSECT  
select Ins_Id from Ins_Course;

select Ins_Id from Instructor 
Except 
select Ins_Id from Ins_Course;


-- intersects Precedence union and except and latest 2 are equal 
