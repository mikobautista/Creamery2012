Feature: Standard Business
	As a user
	I want to be able to view certain information
	So I can have confidence in the system
	
	Background:

	Scenario: Do not see the default rails page
	  When I go to the home page
	  Then I should not see "You're riding Ruby on Rails!"
		And I should not see "About your application's environment"
		And I should not see "Create your database"	

	Scenario: View 'About the Creamery'
		When I go to the About Us page
		Then I should see "About" within "#footer"

	Scenario: View 'Contact Us'
		When I go to the Contact Us page
		Then I should see "Contact" within "#footer"

	Scenario: View 'Privacy Policy'
		When I go to the Privacy page
		Then I should see "Privacy" within "#footer"

	Scenario: View webmaster information in footer
		When I go to the home page
		Then I should see "Webmaster" within "#footer"
	
	Scenario: Navigation exists to link resources
	  When I go to the home page
		And I click on the link "Stores"
	  Then I should see "Listing All Stores" within "h2"
		And I click on the link "Employees"
		Then I should see "Name"
		And I should see "Phone"
		And I should see "Hersh, Jon"
		And I click on the link "Assignments"
		Then I should see "Listing Active Assignments" within "h2"
	
	
	