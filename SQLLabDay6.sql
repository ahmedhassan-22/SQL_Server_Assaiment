

-- 1.	 Create a scalar function that takes a date and returns the Month name of that date. test (‘1/1/2009’)

   Create  function get_month(@date date)			
   returns nvarchar(20)
   begin
   declare @mo varchar(20)				
   select @mo= DateName (month, @date)			
   return @mo
   end
   select dbo.get_month('1/1/2009')

   --2.	Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

   create  function values_ (@int1 int, @int2 int)
	 returns table
	 as 
   	 return
	  (
		select * from Employee 
		where Department_id between @int1 and @int2
	  ) 

				select * from values_(1, 10)

	--3.	Create a tabled valued function that takes Student No and returns Department Name with Student full name.

	alter function GetEmployee(@Emp_num int)
	  returns table
	  as
		return
		  ( select D.Name, CONCAT(e.Fname, ' ', e.Lname) 'Full Name'
		    from Employee e
		    join Department D
		    on D.Department_id = e.Department_id
		    where e.ESSN = @Emp_num   
		  )

		select * from GetEmployee(98576)


		--4.	Create a scalar function that takes Student ID and returns a message to the user (use Case statement)

		--a.	If the first name and Last name are null then display 'First name & last name are null'

		--b.	If the First name is null then display 'first name is null'

		--c.	If the Last name is null then display 'last name is null'
		
		--d.	Else display 'First name & last name are not null'
				
  Create function sc_func(@Emp_num int)
	returns nvarchar(100)
	 as
	begin
    declare @fname nvarchar(20) , @lname nvarchar(20), @ans nvarchar(100)
	  select @fname = Fname, @lname = Lname
	  from Employee
	  where ESSN = @Emp_num
	  select @ans = case
		  when @fname is null and @lname is null  then 'First name And last name are null'
		  when @fname is null						then 'first name is null'
		  when @lname is null						then 'last name is null'
	                else  'First name And last name are not null'
	end 
	return @ans
	end 

				 select  dbo.sc_func(98576) 


 --5.	Create a function that takes an integer that represents the format of 
 --		the Manager hiring date and displays department name, Manager Name, and hiring date with this format.   
		
  create function MGR(@MGR_ID int)
	returns table
	as
	begin
		select D.Name, E.fname, D.MGRssn
		from Employee E
		join Department D
		on e.ESSN = D.MGRssn
		where ESSN = @MGR_ID
	 end
				 select * from MGR(2)

 --6.	Create multi-statements table-valued function that takes a string

          --		If string='first name' returns student first name
		  --		If string='last name' returns student last name 
		  --		If string='full name' returns Full Name from student table 
		--		Note: Use the “ISNULL” function

				create function Employee_Name(@Emp nvarchar(50))
				returns @E table (Employee_Name nvarchar(50))
				as 
				begin
				if @Emp = 'first name' 
				insert into @E(Employee_Name) select isnull(Fname,'Not Found') from Employee
				else if @Emp = 'last name' 
				insert into @E(Employee_Name) select isnull(Lname,'Not Found') from Employee
				else --if @str = 'full name'
				insert into @E select isnull(Fname + ' ' + Lname,'Not Found') from Employee	
					return
				end

				 select * from Employee_Name('full name')


  -- Part 2: Use Company DB

		--1.	Create a function that takes project number and display all employees in this project

   create function proj_num(@proj_ID int)
	 returns table
	 as
	  return
	  (
		select concat(Fname,' ',Lname) 'Name'
		from Employee E
		join Works_on W
		on e.ESSN = W.ESSn
		join Project p
		on P.Id = w.Project_id
		where P.Id = @proj_ID
	  )
				select * from proj_num(10)
