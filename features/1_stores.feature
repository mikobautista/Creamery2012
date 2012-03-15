Feature: Manage stores
	As an administrator
	I want to be able to manage store information
	So I can more effectively run the creamery

	Background:
	  Given an initial business
	
	# READ METHODS
	Scenario: View my stores
		When I go to my stores page
		Then I should see "Current Stores"
		And I should see "Store Name"
		And I should see "Store Phone"
		And I should see "Staff Count"
		And I should see "ACAC"
		And I should see "412-268-3259"
		And I should see "5"
		And I should see "Carnegie Mellon"
		And I should see "412-268-8211"
    And I should see "4"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
			
	Scenario: View store details
		When I go to CMU details page
		Then I should see "Address: "
		And I should see "5000 Forbes Avenue"
		And I should see "Pittsburgh, PA 15213"
		And I should see "Current Employees"
		And I should see "Brunk, Stafford"
		And I should see "Crawford, Cindy"
		And I should not see "Hersh, Jon"
		And I should not see "Rubinstein, Ari"
	
	Scenario: The store name is a link to details
		When I go to my stores page
		And I click on the link "Carnegie Mellon"
		And I should see "5000 Forbes Avenue"
		And I should see "Current Employees"
		And I should see "Brunk, Stafford"
		And I should not see "Rubinstein, Ari"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
	    	
	
	# CREATE METHODS
	
	Scenario: Creating a new store is successful
	  When I go to the new store page
		And I fill in "store_name" with "Glenwood"
		And I fill in "store_street" with "101 Busch Place"
		And I fill in "store_city" with "Pittsburgh"
		And I select "Pennsylvania" from "store_state"
		And I fill in "store_zip" with "15222"
		And I fill in "store_phone" with "7243654922"
		And I press "Create Store"
	  Then I should see "Successfully created Glenwood"
		And I should see "Name: Glenwood"
		And I should see "101 Busch Place"
		And I should see "Active: Yes"
	
	Scenario: Creating a new store fails without a name
	  When I go to the new store page
		And I fill in "store_street" with "101 Busch Place"
		And I fill in "store_city" with "Pittsburgh"
		And I fill in "store_zip" with "15222"
		And I press "Create Store"
	  Then I should see "can't be blank"
	
		
	Scenario: Creating a new store fails without unique name
	  When I go to the new store page
		And I fill in "store_name" with "Carnegie Mellon"
		And I fill in "store_street" with "5000 Forbes Avenue"
		And I fill in "store_city" with "Pittsburgh"
		And I select "Pennsylvania" from "store_state"
		And I fill in "store_zip" with "15213"
		And I press "Create Store"
	  Then I should see "has already been taken"
	
		
	Scenario: Creating a new store fails without a valid zip code
	  When I go to the new store page
		And I fill in "store_name" with "Glenwood"
		And I fill in "store_street" with "101 Busch Place"
		And I fill in "store_city" with "Pittsburgh"
		And I fill in "store_zip" with "15222222"
		And I press "Create Store"
	  Then I should see "should be five digits long"
	
