require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  
  # Relationship macros...
  should belong_to(:shift)
  should belong_to(:job)
  
  
#  # ---------------------------------
#  # Testing other methods with a context
#  context "test" do
#    # create the objects I want with factories
#    setup do
#      @ed = Factory(:employee)
#      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
#      @cmu = Factory(:store)
#      @assignment1 = Factory(:assignment, :store => @cmu, :end_date => nil, :employee => @ed)
#      @assignment2 = Factory(:assignment, :store => @cmu, :end_date => nil, :employee => @cindy)
#      @shift1 = Factory(:shift, :assignment => @assignment1, :end_time => Time.local(2012,12,8,23,59,59))
#      @shift2 = Factory(:shift, :assignment => @assignment2, :date => Date.today, :end_time => Time.local(2000,1,1,11,0,1))
#      @sweepfloor = Factory(:job)
#    end
#  end
#  
end
