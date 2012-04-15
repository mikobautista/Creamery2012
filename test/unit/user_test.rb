require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Test relationships
  should belong_to(:employee)

  # Test format of email
  should allow_value("lol@google.com").for(:email)
  should allow_value("mbautist@andrew.cmu.edu").for(:email)
  should_not allow_value(1).for(:email)  
  should_not allow_value("lol").for(:email)


  context "Creating 1 user" do
    # create the objects I want with factories
    setup do 
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date, :active => false)
      @ed_user = FactoryGirl.create(:user, :employee_id => @ed.id, :email => "ed@google.com", :password => "secret")
    end
    
=begin
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @ed_user.destroy
    end
=end

    # now run the tests:

    should "display the user's name correctly" do
      assert_equal @ed_user.proper_name, "Gruberman, Ed"
    end
    
    should "display the user's role correctly" do
      assert_equal @ed_user.role, "employee"
    end

    should "force employees to have unique email" do
      invalid_user = FactoryGirl.build(:user, :employee => @cindy, :email => "ed@google.com")
      deny invalid_user.valid?
    end

    should "force employees to be active" do
      inactive_user = FactoryGirl.build(:user, :employee => @cindy)
      deny inactive_user.valid?
    end
  end

end
