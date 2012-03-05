require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  
  # Test basic validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  # tests for ssn
  should allow_value("123456789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)
  # test date_of_birth
  should allow_value(17.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(13.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
  # tests for role
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)
  
  
  context "Creating six employees of three levels" do
    # create the objects I want with factories
    setup do 
      @cmu = FactoryGirl.create(:store)
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :active => false, :date_of_birth => 16.years.ago.to_date)
      @ben = FactoryGirl.create(:employee, :first_name => "Ben", :last_name => "Sisko", :role => "manager", :phone => "412-268-2323")
      @kathryn = FactoryGirl.create(:employee, :first_name => "Kathryn", :last_name => "Janeway", :role => "manager", :date_of_birth => 30.years.ago.to_date)
      @alex = FactoryGirl.create(:employee, :first_name => "Alex", :last_name => "Heimann", :role => "admin")
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :end_date => nil)
    end
    
    # and provide a teardown method as well
    teardown do
      @cmu.destroy
      @ed.destroy
      @cindy.destroy
      @ralph.destroy
      @ben.destroy
      @kathryn.destroy
      @alex.destroy
      @assign_ed.destroy
      @assign_cindy.destroy
    end
  
    # now run the tests:
    # test employees must have unique ssn
    should "force employees to have unique ssn" do
      repeat_ssn = FactoryGirl.build(:employee, :first_name => "Steve", :last_name => "Crawford", :ssn => "084-35-9822")
      deny repeat_ssn.valid?
    end
    
    # test scope younger_than_18
    should "show there are two employees under 18" do
      assert_equal 2, Employee.younger_than_18.size
      assert_equal ["Crawford", "Wilson"], Employee.younger_than_18.alphabetical.map{|e| e.last_name}
    end
    
    # test scope younger_than_18
    should "show there are four employees over 18" do
      assert_equal 4, Employee.is_18_or_older.size
      assert_equal ["Gruberman", "Heimann", "Janeway", "Sisko"], Employee.is_18_or_older.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'active'
    should "shows that there are five active employees" do
      assert_equal 5, Employee.active.size
      assert_equal ["Crawford", "Gruberman", "Heimann", "Janeway", "Sisko"], Employee.active.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive employee" do
      assert_equal 1, Employee.inactive.size
      assert_equal ["Wilson"], Employee.inactive.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'regulars'
    should "shows that there are 3 regular employees: Ed, Cindy and Ralph" do
      assert_equal 3, Employee.regulars.size
      assert_equal ["Crawford","Gruberman","Wilson"], Employee.regulars.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'managers'
    should "shows that there are 2 managers: Ben and Kathryn" do
      assert_equal 2, Employee.managers.size
      assert_equal ["Janeway", "Sisko"], Employee.managers.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'admins'
    should "shows that there is one admin: Alex" do
      assert_equal 1, Employee.admins.size
      assert_equal ["Heimann"], Employee.admins.alphabetical.map{|e| e.last_name}
    end
    
    # test the method 'name'
    should "shows name as last, first name" do
      assert_equal "Heimann, Alex", @alex.name
    end    
    
    # test the method 'current_assignment'
    should "shows return employee's current assignment if it exists" do
      assert_equal "CMU", @cindy.current_assignment.store.name
      assert_nil @ed.current_assignment
    end
    
    # test the callback is working 'reformat_ssn'
    should "shows that Cindy's ssn is stripped of non-digits" do
      assert_equal "084359822", @cindy.ssn
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Ben's phone is stripped of non-digits" do
      assert_equal "4122682323", @ben.phone
    end
    
    # test the method 'over_18?'
    should "shows that over_18? boolean method works" do
      assert @ed.over_18?
      deny @cindy.over_18?
    end
    
    # test the method 'age'
    should "shows that age method returns the correct value" do
      assert_equal 19, @ed.age
      assert_equal 17, @cindy.age
      assert_equal 30, @kathryn.age
    end
  end
end
