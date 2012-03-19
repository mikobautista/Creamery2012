Feature: Manage assignments
	As an administrator
	I want to be able to manage employee assignments
	So I can more effectively run the creamery

	Background:
	  Given an initial business
	
	# READ METHODS (TESTING INDEX ONLY)
	Scenario: View active and past assignments
		When I go to the assignments index page
		Then I should see "Current Assignments"
		And I should see "Store"
		And I should see "Employee"
		And I should see "Pay"
		And I should see "Start Date"
		And I should see "Details"
		And I should see "ACAC"
		And I should see "3"
		And I should see "Daigle, Johnny"
		And I should see "Past Assignments"
		And I should see "Gruberman, Ed"


	Scenario: Clicking on employee name takes me to employee page
		When I go to the assignments index page
		And I click on the link "Olbeter, Taylor"
		Then I should see "Employee Details"
		And I should see "Name: Olbeter, Taylor"
		And I should see "Phone: 724-423-4388"
	
	Scenario: Clicking on store name takes me to store page
		When I go to the assignments index page
		And I click on the link "ACAC"
		Then I should see "Store Details"
		And I should see "Name: ACAC"
		And I should see "250 East Ohio"
	
	
	# CREATE METHODS
	
	Scenario: Creating a new assignment is successful
	  When I go to the new assignment page
		And I select "ACAC" from "assignment_store_id"
		And I select "Wakeley, Heather" from "assignment_employee_id"
		And I select "March" from "assignment_start_date_2i"
		And I select "14" from "assignment_start_date_3i"
		And I select "2012" from "assignment_start_date_1i"
		And I select "2" from "assignment_pay_level"
		And I press "Create Assignment"
	  Then I should see "Assignment Details"
		And I should see "ACAC"
		And I should see "Wakeley, Heather"
		And I should see "03/14/12"

	Scenario: Creating a new assignment fails without store
	  When I go to the new assignment page
		And I select "Wakeley, Heather" from "assignment_employee_id"
		And I select "March" from "assignment_start_date_2i"
		And I select "14" from "assignment_start_date_3i"
		And I select "2012" from "assignment_start_date_1i"
		And I select "2" from "assignment_pay_level"
		And I press "Create Assignment"
	  Then I should see "is not an active store at the creamery"
			
	Scenario: Creating a new assignment fails without employee
	  When I go to the new assignment page
		And I select "Carnegie Mellon" from "assignment_store_id"
		And I select "April" from "assignment_start_date_2i"
		And I select "30" from "assignment_start_date_3i"
		And I select "2011" from "assignment_start_date_1i"
		And I select "2" from "assignment_pay_level"
		And I press "Create Assignment"
	  Then I should see "is not an active employee at the creamery"

	
	
