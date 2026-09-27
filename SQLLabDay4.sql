

--   1. 	For each project, list the project name and the total hours per week (for all employees) spent on that project.

			select name, sum(Hours) 'The Total Hours per Week'
			from Project
			join WORKS_ON
			on id = WORKS_ON.Project_id
			group by name

--		2.	Display the data of the department which has the smallest employee ID over all employees' ID.

			select *
			from Department
			where Department_id = (select top(1) e.Department_id 
						  from Employee e
						  where e.Department_id is not null
						  order by ESSN	
						  )
						 
--		3.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

			select D.name, MAX(Salary) 'MAX Salary', MIN(Salary) 'MIN Salary', AVG(Salary) 'AVG Salary'
			from Employee e
			join Department d
			on D.Department_id = e.Department_id
			group by D.name

--		4.	List the last name of all managers who have no dependents.
			
			select lname
			from Department d
			join Employee e
			on ESSN = MGRSSN
			left join Dependent n
			on e.ESSN = n.ESSN
			where e.ESSN is null

--		5.	For each department-- if its average salary is less than the average salary of all employees-- 
--			display its number, name and number of its employees.
			
			select Department_id, count(*) 'Number of Employees ', AVG(Salary) 'AVG_Salary'
			from Employee
			group by Department_id
			having AVG(Salary) < (select avg(Salary) from Employee)

--		6.	Retrieve a list of employees and the projects they are working on ordered by department 
--			and within each department, ordered alphabetically by last name, first name.
			
			select Fname + ' ' + Lname 'Name', P.name
			from Department d
			join Employee e
			on D.Department_id = e.Department_id
			join Works_on w
			on e.eSSN = w.ESSn
			join Project p
			on P.Id = w.Project_id
			order by e.Department_id, Lname, Fname

--		7.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

			update Employee
			set Salary = (Salary + (Salary / 0.3))
			where ESSN in (
			select ESSN
			from Employee
			join Works_on
			on Employee.ESSN = WORKS_ON.ESSn
			join Project
			on Project.Id = WORKS_ON.Project_id
			where Project.Id = 'Al Rabwah')

			-- select * from Employee where SSN = 223344

--		8.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.

			select eSSN, Fname + ' ' + Lname 'Name'
			from Employee
			where EXISTS(
						select ESSN
						from Dependent
						where eSSN = ESSN 
						)
			
			/*select *
			from Employee
			right join Dependent
			on SSN = ESSN*/