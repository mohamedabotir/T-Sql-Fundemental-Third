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
select  dbo.Course.Top_Id ,dbo.Course.Crs_Duration ,count(Top_Id) as [counts top] from dbo.Course group by dbo.Course.Top_Id,dbo.Course.Crs_Duration having dbo.Course.Top_Id>20 order by Top_Id asc;
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
select Course.Top_Id,Course.Crs_Duration ,row_number() over(partition by Course.top_id  ) from Course 

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
/*char and nchar char is used for fixed length and take 1 byte for each character but nchar take 2 bytes for each character used to support multi language
char is poor for reading data but efficient for updating data

varchar is variable and take 1 byte for each character (take length of row + two bytes as offset data) nvarchar take 2 bytes
varchar is useful for reading but not efficeint in updating

*/
select name,description from sys.fn_helpcollations();

/*if database not casesensetive you can't create table like T1 and t1 as schema shows two is same */
select * from Instructor;
insert into Instructor (Ins_Id,Ins_Name,Ins_Degree,Salary,Dept_Id) values (16,'ahmed','master',25412,30);

select * from Instructor where ins_name collate Latin1_General_CS_AI = N'Ahmed';

/*
QUOTED_IDENTIFIER is allow database to follow sql standered by turning it on use single qoute to character and double for table or column 
*/
select 'i''am mohamed'

/*
For other operations on character strings, T-SQL provides several functions, including SUBSTRING, LEFT, RIGHT, 
LEN, DATALENGTH, CHARINDEX, PATINDEX, REPLACE, REPLICATE, STUFF, UPPER, LOWER, RTRIM, 
LTRIM, and FORMAT
*/

select 'i''am mohamed'  +  ' my nationality is egyptian'

select ins_name,coalesce(Salary,'') from Instructor;

select ins_name,concat(Salary,'') from Instructor;

select substring('abcdefg',1,4) --if start with  0 will get char to n-1 (4-1) otherwise will get char to (n) 
--never return error if length exceed character length 

select left('abcdefg',4)

select right('abcdefg',4)

select len('abcdefg')

select datalength('abcdefg')

select charindex('c','abcdefg',0) --return zero if not found

select patindex('%[0-9]%','abc123defg')

select len('abbcdefg')-len(REPLACE('abbcdefg','b','')) -- count specific char using replace

select  REPLACE('abbcdefg','b','')

select REPLICATE('abcdefg',3) -- repeat

select Ins_Id,right(REPLICATE('0',8) + CAST(Salary as Varchar(15)),15) from Instructor

/*stuff removing data and insert other*/
select stuff('abcdefg',1,1,'stuff ')

select UPPER('abcdefg')

select LOWER('abcdefg')

select RTRIM('      abcdefg      ')

select LTRIM('      abcdefg      ')

select format(54250512.624,'00,00.00')

select Ins_Name from Instructor where ins_name like N'[^A-I]%'


insert into Instructor (Ins_Id,Ins_Name,Ins_Degree,Salary,Dept_Id) values (17,'_ali','master',25412,30);

select Ins_Name from Instructor where ins_name like N'%!_%' escape '!' -- for search about wildcard we use escape or  []

select Ins_Name from Instructor where ins_name like N'%[_]%'


 
select Cast('2007-02-15 12:30:12' as datetimeoffset(7)) -- 7 mean acuuracy to 100 nanoseconds

select name,description from sys.fn_helpcollations()

set language british
select Cast('02-8-2022 12:30:12' as datetimeoffset(7))

set language us_english
select Cast('02-8-2022 12:30:12' as datetimeoffset(7))


select convert(datetime,'02-8-2022 12:30:12',101) --mm/dd/yyyy

SELECT PARSE('02/12/2007' AS DATETIME USING 'en-US');
/*
return null if can't parse or convert or cast
try_cast
try_parse
try_convert
*/
/*
GETDATE, 
CURRENT_TIMESTAMP, GETUTCDATE, SYSDATETIME, SYSUTCDATETIME, SYSDATETIMEOFFSET, CAST, 
CONVERT, SWITCHOFFSET, TODATETIMEOFFSET, DATEADD, DATEDIFF, DATEPART, YEAR, MONTH, 
DAY, DATENAME, various FROMPARTS functions, and EOMONTH. 
The functions SYSDATETIME, SYSUTCDATETIME, SYSDATETIMEOFFSET, SWITCHOFFSET, and 
TODATETIMEOFFSET were introduced in SQL Server 2008. Existing functions were enhanced 
to support the newer types and parts. The various FROMPARTS functions and the EOMONTH
function were introduced in SQL Server 2012. 
*/

select getdate()
select CURRENT_TIMESTAMP
select GETUTCDATE()
select SYSDATETIME()
select SYSDATETIMEOFFSET()

select SWITCHOFFSET(SYSDATETIMEOFFSET(),'-02:00')

select todatetimeoffset(SYSDATETIME(),'-02:00') -- merge only put datetime beside timezone only

select DATEADD(year,1,'20220203')

select datediff(MONTH,'20220203','20220903')

select datepart(MONTH,'20220203') 

select datepart(MONTH,'20220203')  where year('20220203') = 2022

select DATENAME(MONTH,'20220203')

select ISDATE('20220203')




/*

DATEFROMPARTS (year, month, day)
DATETIME2FROMPARTS (year, month, day, hour, minute, seconds, fractions, precision)
DATETIMEFROMPARTS (year, month, day, hour, minute, seconds, milliseconds)
DATETIMEOFFSETFROMPARTS (year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision)
SMALLDATETIMEFROMPARTS (year, month, day, hour, minute)
TIMEFROMPARTS (hour, minute, seconds, fractions, precision)
*/

select DATEFROMPARTS(2022,02,03)

select EOMONTH('20220203')


SELECT schema_name(SCHEMA_ID) [schema name] ,name AS table_name
FROM sys.tables;


select name ,TYPE_NAME(system_type_id),max_length,collation_name,is_nullable from sys.columns where object_id = OBJECT_ID(N'Course')


SELECT 
 COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
 COLLATION_NAME, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = N'Course' 
 

 SELECT 
 TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES 