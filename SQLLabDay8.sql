

--		1. Display all the data from the Employee table (HumanResources Schema) As an XML document “Use XML Raw”.
--			“Use Adventure works DB”
--		A) Elements
--		B) Attributes
	
		-------------- Elements ------------------
			select * from dbo.Employee
			for xml auto, elements 

			select * from dbo.Employee for xml path
		

		------------- Attributes ------------------
			select * from dbo.Employee
			for xml auto
			
			select * from dbo.Employee
			for xml raw('HumanResources.Employee')

--		2. Display Each Department Name with its instructors. “Use ITI DB”
--		A) Use XML Raw :


		select e.fName , d.Name
		from Department d
		join Employee e
		on d.Department_id = e.Department_id
		for xml raw ('manger'), elements, Root('Employee_mangers')


--		B) Use XML Path:


		select D.Department_id "@id", D.Name "department/name", E.fName "department/manger_name" 
		from Department D
		join Employee E
		on D.Department_id = E.Department_Id
		for xml path ('Employee_mangers')

--		3. Use the following variable to create a new table “customers” inside the company DB. Use OpenXML
			
		declare @xml_code xml =
			'<customers>
				<customer FirstName="Bob" Zipcode="91126">
					<order ID="12221">Laptop</order>
				</customer>
				<customer FirstName="Judy" Zipcode="23235">
					<order ID="12221">Workstation</order>
				</customer>
				<customer FirstName="Howard" Zipcode="20009">
					<order ID="3331122">Laptop</order>
				</customer>
				<customer FirstName="Mary" Zipcode="12345">
					<order ID="555555">Server</order>
				</customer>
			</customers> '
		declare @handle int  
		exec sp_xml_preparedocument @handle output, @xml_code

		select * from 
		openxml (@handle, '//customer')
		with(
			Frist_Name varchar(20) '@FirstName',
			ZipCode		int			'@Zipcode',
			Order_ID	int			'order/@ID',
			Item		varchar(30) 'order'
			)	
		

--		using AdventureWorks2012 database:
--		4. Create an index on column (Hiredate) that allows you to cluster the data in the table Department. What will happen?
			
			
			create nonclustered index cl_Bdate
			on dbo.employee(bdate)

			exec sp_helpindex [dbo.employee]

--		5. Create an index that allows you to enter unique ages in the student table. What will happen?
			
			-- Error will happen because there is duplicated values in age column 
			-- and unique nonclusterd like 'Unique Constraints' all values in column must be unique

			create unique nonclustered index unique_MGRssn
			on Department(MGRssn)

			select * from Department

--		6. create a non-clustered index on column(Manager_hiredate) that allows you to enter 
--			a unique instructor id in the table Department.
			
			create  nonclustered index noncluster_Manager_hiredate
			on Department(Name)
			
			create unique nonclustered index unique_noncluster_insId
			on Department(MgrStartdate)
			
			exec sp_helpindex Department
			
			 drop index unique_noncluster_insID on Department
	
			

--		7. find the count of times that Ahmed appear Khalid after Khalid in st_Fname column (using the cursor)
			
			Declare c cursor
			for 
			select Fname 
			from Employee
			where Fname = 'Ahmed' or Fname = 'Abdo'
			for read only
			declare @fname1 varchar(30), @fname2 varchar(30), @cnt int
			set @cnt = 0
			open c
			fetch c into @fname1				
			while @@FETCH_STATUS = 0	
			begin
			if @fname2 = 'Ahmed' and @fname1 = 'Abdo'
				begin select @cnt+=1 end
			select @fname2 = @fname1
			fetch c into @fname1			
			end
			select @cnt
			close c
			deallocate c

				select * from Employee
			
			
			