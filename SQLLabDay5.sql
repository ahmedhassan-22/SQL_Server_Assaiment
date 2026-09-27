
--1.	 Create a view that displays the student’s full name, course name if the student has a grade of 
		--			more than 50.

				create view vgradmorethan50 as(
				select  e.Fname + ' ' + e.Lname 'Employee Name'
				from Employee e 
				join Department d
				on D.Department_id = e.Department_id
				where salary > 50000
				)
				
				-- Select * from vgradmorethan50
			
		--2.	 Create an Encrypted view that displays manager names and the topics they teach. 

				Create View V_Managers with encryption as(
				select fName, lName
				from Employee e
				join Department d
				on  d.Department_id = e.Department_id
				join Dependent p
				on e.ESSN = p.ESSN
				join WORKS_ON w
				on  e.ESSN = w.ESSN
				join Project pro
				on d.Department_id = pro.Department_id
				 )
				-- select * from V_Managers

		--3.	 Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “.
				Create View v as(
				select e.fName, d.Name
				from Employee e
				join Department d
				on d.Department_id = e.Department_id
				where D.Name = 'SD' or D.Name = 'Java' 
				 )
		
		--4.	Create a view “V1” that displays student data for the student who lives in Alex or Cairo.
		--		Note: Prevent the users to run the following query Update V1 set st_address=’tanta’  Where st_address=’alex’;
				Create V1 as(
				select *
				from Employee
				where Address like '%Alex%' or Address like '%Cairo%'
				)
				

		--5.	Create a temporary table [Session based] on Company DB to save employee name and his today task.
		
				Create table #emp
				(
				emp_name nvarchar(20),
				Today_task date,
				)

		
		--------------	Part2:Use CompanyDB	---------------------------
		
		--1)	Create a view that will display the project name and the number of employees works on it.
				--Create View 
				select  COUNT(*) 'Number Of Employees',Project.NAME
				from [DESKTOP-ILUI0AS].[MyCompany].[dbo].[Employee] 
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Works_on]
				on Employee.eSSN = WORKS_ON.ESSn
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Project]
				on Project.Id = Project.Department_id
				group by Project.NAME		--Pnumber

				-- select * from [DESKTOP-5PBODIS\SQLEXPRESS].Company_SD.[dbo].[Project]
		
		--2)	Create a view named   “v_D30” that will display employee number, project number, hours of the projects in department 30.
				
				Create View v_D30 as(
				select Employee.eSSN, Project.NAME, Hours
				from [DESKTOP-ILUI0AS].[myCompany].[dbo].[Employee] 
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Works_on]
				on employee.eSSN = WORKS_ON.ESSn
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Project]
				on Project.Id = Project.id 
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Department]
				on Department. = Project.Department_id
				where Department_id = 30)

				--select * from v_D30
				
				--DROP VIEW   v_D30
				

		--3)	Create a view named  “v_count “ that will display the project name and the number of hours for each one. 
				
				Create View v_count as(
				select Project.NAME 'Project Name', sum(Hours) 'Hours'
				from [DESKTOP-ILUI0AS].[myCompany].[dbo].[Project]
				join [DESKTOP-ILUI0AS].[myCompany].[dbo].[Works_on]
				on Project.Id = Project_id
				group by Project.name
				)
				--select * from v_count
		
		--4)	Create a view named ” v_project_500” that will display the emp no. for the project 500, 
		--		use the previously created view  “v_D30”
				
				Create View v_project_500 as(
				select eSSN 
				from v_D30
				where Project.Id = 500
				)
		--		select * from v_project_500


		--6)	modify the view named  “v_without_budget”  to display all DATA in project 300 and 400
				
				Create View v_without_budget as(
				select *
				from [DESKTOP-ILUI0AS].[myCompany].[dbo].[Project]
				where Project.Id = 300 and Project.Id = 400


		--7)	Delete the views  “v_D30” and “v_count”
	

				 DROP VIEW   v_D30
				 DROP VIEW   v_count


			 