
----------------------------------------------- Lab Day 7 -------------------------------------------------------------

--		1.  Create a stored procedure to show the number of students per department.

	create proc sp_count_Employee
	as
	select count(*) 'Numbers of Employee' 
	from Employee E
	join Department D
	on D.Department_id = E.Department_id
	group by D.Department_id
			
			 Execute sp_count_Employee


--		2.	Create a stored procedure that will check for the # of employees in the project p1 
--			if they are more than 3 print a message to the user “'The number of employees in the project p1 is 3 or more'”
--			if they are less display a message to the user “'The following employees work for the project p1'” in addition 
--			to the first name and last name of each one. [Company DB] 
--			 With exist Try it 
			
   create proc sp_check_emp_in_proj (@P_ID int)
	as
	declare @cnt int
	select @cnt= (select count(*) 'Number of Employees in Project'
	from Employee e
	join Works_on w 
	on e.ESSN = w.ESSn
	join Project p   
	on P.Id = w.Project_id
	where P.Id = @P_ID)
	if( @cnt > 3) 
	begin 
	print('The number of employees in the project is 3 or more') 
	end
	else
	begin 
	print('The following employees work for the project')
	select Fname, Lname
	from Employee E
	join WORKS_ON W
	on E.ESSN = W.ESSn
	join Project P 
	on P.Id = W.Project_id
	where P.Id = @P_ID
	end
	Go
	exec sp_check_emp_in_proj 10
	Go
	exec sp_check_emp_in_proj 20	
	Go




--		3.	Create a stored procedure that will be used in case there is an old employee has left the project 
--			and a new one become instead of him. The procedure should take 3 parameters 
--			(old Emp. number, new Emp. number and the project number) and 
--			it will be used to update works_for table.[Company DB]
			
	Alter PROC sp_emp_proj
    @old_id INT,
    @new_id INT,
    @proj_num INT
    AS
  BEGIN
    UPDATE WORKS_ON
    SET ESSN = @new_id
    WHERE ESSN = @old_id
      AND Project_id = @proj_num;
  END
     GO
   EXEC sp_emp_proj 453453453, 1125, 1

			select * from Employee
	
			select * from WORKS_ON
	
	
	
--		4.  Create an Audit table with the following structure
--		   __________________________________________________________________
--		   | ProjectNo | UserName  |  ModifiedDate  | Hours_Old | Hours_New |
--		   |‾‾‾‾p2‾‾‾‾‾|‾‾‾‾Dbo‾‾‾‾|‾‾‾2008-01-31‾‾‾|‾‾‾‾10‾‾‾‾‾|‾‾‾‾20‾‾‾‾‾|
--		   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
--			This table will be used to audit the update trials on the Hours column (works_for table, Company DB)
--	Example:
--			If a user updated the Hours column then the project number, the user name that made that update, 
--			the date of the modification and the value of the old and the new Hours will be inserted into the Audit table
--			Note: This process will take place only if the user updated the Hours column
				
		create table Audit( Project_No int, UserName nvarchar(30), ModifiedDate date,Hours_Old int, Hours_New int )

		create trigger hours_trigger
		on works_on
		after update 
		 as
		 begin
			if UPDATE (Hours)
			  begin
				declare @Hours_old int, @Hours_new int, @p_id int
				select @Hours_old = Hours from deleted
				select @Hours_new = Hours from inserted
				select @p_id = Project_id from Works_on 
				insert into Audit(Project_No, UserName, ModifiedDate,Hours_Old, Hours_New )
				values ( @p_id, suser_name(), GETDATE(), @Hours_old, @Hours_new)
				select * from Audit
		      end
	 	 end

				select * from Works_on
				update Works_on set Hours= 33 where ESSn=123456789
				

	--		5.  Create a trigger to prevent anyone from inserting a new record in the Department table 
    --			Print a message for the user to tell him that he ‘can’t insert a new record in that table’
			
  create trigger t1
	on department
	instead of insert
	as
	print('can’t insert a new record in that table')

   insert into Department(Department_id, Name) values(11, 'Test')


   --   6.   Create a trigger that prevents the insertion Process for the Employee table in September and test i  

   	create trigger t3
	  on Employee
	  after insert
	  as
	  declare @get_Month int
	  select @get_Month= (select MONTH(getdate()))
	  if @get_Month=12		
	  begin
	  print ('Can''t Insert in This Month')
	  rollback
	  end

			 insert into Employee(ESSN, Fname) values(100, 'Test')


 ---  	7.  Create a trigger that prevents users from altering any table in Company DB.
			
			create  trigger prev_alter
			on database 
			for alter_table
			as
			begin 
				ROLLBACK TRANSACTION
			end

			 drop trigger prev_alter			--Cannot drop the trigger 'prev_alter'

			 ALTER TABLE employee ADD Email nvarchar(255)
			 ALTER TABLE employee drop column Email 
			 select * from Employee


----   8.  Create a trigger on student table after insert to add Row in 
--			a Student Audit table (Server User Name, Date, Note) where the note will be 
--			“[username] Insert New Row with Key=[Key Value] in table [table name]”
--			_________________________________
--			| Server User Name | date | Note |
--	 		|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾‾‾‾‾|‾‾‾‾‾‾|	
--			‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
			Create table Em_Audit(ser_user_name nvarchar(50), date_ date, Note nvarchar(200))
			
			create trigger st_trigger
				on Employee
				after insert 
				as
				begin
				declare @s_id int
				select @s_id= Essn from inserted
					insert into Em_Audit(ser_user_name, date_ ,Note )
					values (suser_name(), GETDATE(), CONCAT(@@SERVERNAME,'Insert New Row with Key =', 
					str(@s_id),' in table Employee'))
					select * from Em_Audit
				end

				 insert into Employee(ESSN, Fname) values(45,'Test')
	


	--  9.  Create a trigger on student table instead of delete to add Row in Student Audit table 
    --			(Server User Name, Date, Note) where the note will be“ try to delete Row with Key=[Key Value]”
			
	
create trigger Em_trigger_del
    on Employee
    instead of delete 
	as
  begin
	declare @s_id int
	select @s_id= Essn from deleted
	insert into Em_Audit(ser_user_name, date_ ,Note )
	values (
	suser_name(), 
	GETDATE(), 
	CONCAT(@@SERVERNAME,' Try to delete Row with Key= ', 
	str(@s_id)))
	select * from Em_Audit
  end
				
GO
 delete from Employee where Essn=22