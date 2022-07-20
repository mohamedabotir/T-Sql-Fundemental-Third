-- didn't work because local select * from #MyOrderTotalsByYear;
select * from ##Globals;

INSERT INTO dbo.##Globals(id, val) VALUES(12, CAST('mohamed' as varchar));

