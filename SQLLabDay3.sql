---- 1.	Display all the employees Data.
select * from Employee

---- 2.	Display the employee First name, last name, Salary and Department number.
select fname , lname ,salary , Department_id
from Employee 

---- 3.	Display all the projects names, locations and the department which is responsible about it.
select p.NAME, p.LOCATION , d.name
from project p join Department d
on p.Department_id = d.Department_id

---- 4.	If you know that the company policy is to pay an annual commission for each employee with 
--	specific percent equals 10% of his/her annual salary .Display each employee full name and 
--	his annual commission in an ANNUAL COMM column (alias).
select fname+ ' '+ lname as full_name ,salary *12 *0.10 'ANNUAL COMM'
from Employee

---- 5.	Display the employees Id, name who earns more than 1000 LE monthly.
select essn , fname, lname 
from Employee 
where salary > 1000 

---- 6.	Display the employees Id, name who earns more than 10000 LE annually.
select essn , fname+' '+ lname as Name , salary
from Employee 
where salary*12 *0.10 > 10000 

---- 7.	Display the names and salaries of the female employees 
select fname+' '+lname as _Name , salary
from Employee
where Sex = 'f'

---- 8.	Display each department id, name which managed by a manager with id equals 333445555.
select Department_id, name
from Department
where MGRSSN = 333445555

---- 9.	Dispaly the ids, names and locations of  the pojects which controled with department 3.
select p.id, P.NAME,P.LOCATION , d.Department_id
from project p join Department d
on p.Department_id = d.Department_id
where d.Department_id =3

---- 10.	Display the Department id, name and id and the name of its manager.
select Dept.Department_id, Dept.name,essn as Manager_id, fname + ' '+ lname "Manager"
from Department dept
join Employee
on eSSN=MGRSSN

---- 11.	Display the name of the departments and the name of the projects under its control.
select d.name , P.NAME
from Department d  join PROJECT p
on p.Department_id = d.Department_id

---- 12. Display the full data about all the dependence associated with 
--  the name of the employee they depend on him/her.
select fname + ' ' + lname "Employee Name", D.*
from Employee E
join DEPENDENT D  
on E.ESSN=D.ESSN

---- 13.	Display the Id, name and location of the projects in Cairo or Alex city.
select P.id , P.NAME , P.LOCATION
from project p
where P.LOCATION = 'alex' or P.LOCATION  = 'cairo'

---- 14.	Display the Projects full data of the projects with a name starts with "a" letter. 
select * from PROJECT p
where P.NAME like 'a%'

---- 15.	display all the employees in department 3 whose salary from 1000 to 2000 LE monthly
select * from Employee E join Department D
on D.Department_id = E.Department_id
where d.Department_id = 3 and salary between 1000 and 10000

---- 16.	Retrieve the names of all employees in department 10 
--  who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT Fname + ' ' + Lname AS Employee_Name
FROM Employee E
JOIN Department D
    ON D.Department_id = E.Department_id
JOIN Project 
    ON D.Department_id = Project.Department_id
JOIN WORKS_ON
    ON E.Essn = WORKS_ON.Essn
    And Project.id = WORKS_ON.Project_id
WHERE D.Department_id = 3
  AND Project.name = 'Book library A'
  AND WORKS_ON.HOURS >= 10

---- 17.	Find the names of the employees who directly supervised with Franklin Wong.
select su.fname + ' ' + su.lname 'Employee Name'
 from Employee e
  join Employee su 
  on e.ESSN = su.Superssn	
where e.Fname ='Franklin' and e.lname='Wong'
		
----  19.	For each project located in Cairo City , find the project number, the controlling 
--		department name ,the department manager last name ,address and birthdate.
select P.id, D.name, E.fname + ' ' + E.lname 'Manager Name', E.Address, E.BDate
 from Employee E
 join Department D
	on MGRSSN = ESSN
 join Project P
	on D.Department_id = P.Department_id 
where E.Address = 'Houston'

---- 20.	Display All Data of the mangers
select *
  from Employee E
join Department D
  on MGRSSN = ESSN
join Project P
  on D.Department_id = P.Department_id 
join WORKS_ON
  on p.id = works_on.Project_id
left join Dependent
  on E.ESSN = Dependent.ESSN		

--	21.	Display All Employees data and the data of their dependents even if they have no dependents

select *
 from Employee E
 full join Department D
	on d.Department_id = e.Department_id
 full join Project P
	on D.Department_id = P.Department_id 
 full join WORKS_ON
	on p.id= works_on.Project_id
 full join Dependent 
	on e.ESSN = Dependent.ESSN

------	1.	Insert your personal data to the employee table as a new employee in 
--		department number 30, SSN = 102672, Superssn = 112233, salary=3000.
		
	insert into Employee(Fname,Lname, Sex, Department_id, ESSN, Superssn, Salary)
	values ( 'Ahmed', 'Hassan', 'M', 2, 98576, null, 3000)
	 
------	2.	Insert another employee with personal data your friend as new employee in department number 
--		30, SSN = 102660, but don’t enter any value for salary or manager number to him.
			
		insert into Employee(Fname,Lname, Sex, Department_id, ESSN)
		values ( 'Abdo', 'Mohamed', 'M', null, 102660)

------	3.	Upgrade your salary by 20 % of its last value.
		
update Employee
  set Salary = Salary + (Salary * 0.2)
where ESSN = 102672

select * from Employee
where ESSN = 102672

select * from Employee 
order by NEWID()