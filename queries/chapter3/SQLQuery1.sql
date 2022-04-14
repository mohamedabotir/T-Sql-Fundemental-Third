
use ITI
select * from Course cross join Ins_Course

create table digits (number int);

insert into digits(number) values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)

select d.number*100+a.number*10+f.number+1 from digits as f cross join digits as  a cross join digits as  d

--inner join is default we can write only join (cartesian and filter)

select * from Course as c inner join Ins_Course as i on c.Crs_Id = i.Crs_Id

--outer join is Cartesian Product, Filter, and Add Outer Rows ,maintain or get null values form it's side to preserve table and this occure in add phase

select * from Student as c right join Department as dep on c.Dept_Id = dep.Dept_Id

-- if we need filter produced we can use where 

select * from Student as c right join Department as dep on c.Dept_Id = dep.Dept_Id
