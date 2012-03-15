Feature: Manage employees
	As an administrator
	I want to be able to manage employee data
	So I can more effectively run the creamery

	Background:
	  Given an initial business
	
	# READ METHODS
	Scenario: View my employees
		When I go to my employees page
		Then I should see "Name"
		And I should see "Phone"
		And I should see "Currently Assigned"
		And I should see "Role"
		And I should see "Brunk, Stafford"
		And I should see "412-268-3257"
		And I should not see "4122683257"
		And I should see "Carnegie Mellon"
		And I should see "Manager"
		And I should not see "Ssn"
	    And I should not see "234567892"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		
	Scenario: The store name in all employees is a link to store details
		When I go to my employees page
		And I click on the link "Carnegie Mellon"
		And I should see "5000 Forbes Avenue"
		And I should see "Current Employees"
		And I should see "Brunk, Stafford"
		And I should not see "Rubinstein, Ari"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"		
	
	Scenario: The employee name in all employees is a link to employee details
		When I go to my employees page
		And I click on the link "Brunk, Stafford"
		Then I should see "Employee Details:"
		And I should see "Brunk, Stafford"
		And I should see "412-268-3257"
		And I should not see "Rubinstein, Ari"
		And I should not see "Schell, Evan"
		
	Scenario: View employee details for active employee
		When I go to details on Evan Schell
		Then I should see "Schell, Evan"
		And I should see "Phone: 412-268-4209"
		And I should not see "Phone: 4122684209"
		And I should see "Date of Birth: 03/15/92"
		And I should not see "Date of birth: 1992-03-15"
		And I should see "SSN: 567890123"
		And I should see "Role: Employee"
		And I should see "Active: Yes"
		And I should see "Assignment History:"
		And I should see "ACAC"
		And I should see "Convention Center"
		And I should not see "Carnegie Mellon"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		
	Scenario: The store name in employee details is a link to store details
		When I go to details on Evan Schell
		And I click on the link "Convention Center"
		Then I should see "1000 Fort Duquesne Blvd"
		And I should see "Pittsburgh, PA 15222"
		And I should see "Current Employees"
		And I should see "Schell, Evan"
		
	    	
	# CREATE METHODS
	
	Scenario: Creating a new employee is successful
	  When I go to the new employee page
		And I fill in "employee_first_name" with "Zaphod"
		And I fill in "employee_last_name" with "Beeblebrox"
		And I fill in "employee_ssn" with "333 22 4444"
		And I fill in "employee_phone" with "724.364.9511"
		And I select "April" from "employee_date_of_birth_2i"
		And I select "30" from "employee_date_of_birth_3i"
		And I select "1993" from "employee_date_of_birth_1i"
		And I select "Employee" from "employee_role"
		And I check "employee_active"
		And I press "Create Employee"
	  Then I should see "Successfully created Zaphod Beeblebrox"
		And I should see "Name: Beeblebrox, Zaphod"
		And I should see "Date of Birth: 04/30/93"
		And I should see "Phone: 724-364-9511"
		
	Scenario: Creating a new employee fails without a name
	  When I go to the new employee page
		And I fill in "employee_ssn" with "333 22 4444"
		And I fill in "employee_phone" with "724.364.9511"
		And I select "April" from "employee_date_of_birth_2i"
		And I select "30" from "employee_date_of_birth_3i"
		And I select "1993" from "employee_date_of_birth_1i"
		And I select "Employee" from "employee_role"
		And I check "employee_active"
		And I press "Create Employee"
		Then I should not see "Successfully created Zaphod Beeblebrox"
	  And I should see "can't be blank"
		
	Scenario: Creating a new employee fails with bad SSN
	  When I go to the new employee page
		And I fill in "employee_first_name" with "Zaphod"
		And I fill in "employee_last_name" with "Beeblebrox"
		And I fill in "employee_ssn" with "333 222 4444"
		And I fill in "employee_phone" with "724.364.9511"
		And I select "April" from "employee_date_of_birth_2i"
		And I select "30" from "employee_date_of_birth_3i"
		And I select "1993" from "employee_date_of_birth_1i"
		And I select "Employee" from "employee_role"
		And I check "employee_active"
		And I press "Create Employee"
	  Then I should see "should be 9 digits"
		And I should not see "Successfully created Zaphod Beeblebrox"
		When I fill in "employee_ssn" with "333-22-4444"
		And I press "Create Employee"
		Then I should see "Successfully created Zaphod Beeblebrox"
		
			
	Scenario: Creating a new employee fails with underage employee
	  When I go to the new employee page
		And I fill in "employee_first_name" with "Zaphod"
		And I fill in "employee_last_name" with "Beeblebrox"
		And I fill in "employee_ssn" with "333 22 4444"
		And I fill in "employee_phone" with "724.364.9511"
		And I select "December" from "employee_date_of_birth_2i"
		And I select "31" from "employee_date_of_birth_3i"
		And I select "1999" from "employee_date_of_birth_1i"
		And I select "Employee" from "employee_role"
		And I check "employee_active"
		And I press "Create Employee"
		Then I should not see "Successfully created Zaphod Beeblebrox"
		And I should see "must be at least 14 years old"
