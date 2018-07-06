use booksDB

--1)
create function CntOfBookWoutCat()
returns int
as
begin
declare @c int
select @c = count(b.name) from books b
where  b.id_category is null
return @c
end 
go
select dbo.CntOfBookWoutCat()
--2)
create function CntOfBookPressTheme()
returns table
as
return(select p.name as pname, t.name as tname, count(b.name) as counts from books b, press p, themes t
where b.Id_press = p.id and b.Id_theme = t.id
group by p.name, t.name
)
go
select * from dbo.CntOfBookPressTheme()
--3)
create function ListOfBook (@bname nvarchar(255), @btheme nvarchar(255), @bcategory nvarchar(255), @bpress nvarchar(255))
returns @table table (b_name nvarchar(255), b_theme nvarchar(255), b_category nvarchar(255), b_press nvarchar(255))
as
begin
Declare @tempTable TABLE (b_name nvarchar(255), b_theme nvarchar(255), b_category nvarchar(255), b_press nvarchar(255))
begin 
insert @tempTable select b.name as bname, t.name as tname, c.name as cname, p.name as pname 
from books b, themes t, category c, press p 
where b.Id_press = p.id and b.id_category = c.id and b.Id_theme = t.id
and b.name = @bname and t.name = @btheme and c.name = @bcategory and p.name = @bpress
order by p.name asc
end
begin 
insert @table select * from @tempTable
end
return
end
go
select * from ListOfBook('Основы работы на ПК', 'Использование ПК в целом', 'Учебники', 'BHV С.-Петербург')
--4)
create function MinValue (@num1 int, @num2 int, @num3 int)
returns int 
as
begin
Declare @val int 
if(@num1<@num2 and @num1<@num3)
set @val = @num1
else if(@num2<@num1 and @num2<@num3)
set @val = @num2
else if(@num3<@num1 and @num3<@num2)
set @val = @num3
return @val
end
go
select dbo.MinValue(4,7,5)
--5)
create function MyFunction2(@num int)
returns int
as
begin
Declare @val1 int, @val2 int
if(@num>9 and @num<100)
begin
set @val1 = @num/10
set @val2 = @num%10 
if(@val1 < @val2)
return @val2
else if(@val1 > @val2)
return @val1
else return -1
end
return -2
end
go
create procedure MyProcedure @num int
as
declare @res int
select @res = dbo.MyFunction2(@num)
if(@res = -2)raiserror('Число не двухразрядное!!!',0,1)
else if(@res = -1) raiserror('Разряды числа равны!!!',0,1)
else raiserror('Разряд %d является большим',0,1, @res)
go 
Execute MyProcedure 98