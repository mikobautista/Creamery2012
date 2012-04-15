require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase

  # Relationship macros...
  should belong_to(:shift)
  should belong_to(:job)
  
  ## ---------------------------------
  # Testing other methods with a context
  context "Creating two shiftjobs" do
    # create the objects I want with factories
    setup do 
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @cmu = FactoryGirl.create(:store)
      @assign_ed = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @ed)
      @assign_cindy = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @cindy)
      @shift_ed = FactoryGirl.create(:shift, :date => Date.today, :assignment => @assign_ed, :end_time => Time.local(2012,12,8,23,59,0))
      @shift_cindy = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => Date.today, :start_time => Time.local(2012,1,1,0,0,0), :end_time => nil)
      @job_ed = FactoryGirl.create(:job, :name => "Ed's job", :active => true)
      @job_cindy = FactoryGirl.create(:job, :name => "Cindy's job", :active => false)
    end
    
=begin
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cindy.destroy
      @cmu.destroy
      @assign_ed.destroy
      @assign_cindy.destroy
      @shift_ed.destroy
      @shift_cindy.destroy
      @job_ed
      @job_cindy
    end
=end

    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert_equal "Ed", @ed.first_name
      assert_equal "Cindy", @cindy.first_name
      assert @assign_ed.end_date == nil
      assert @assign_cindy.end_date == nil
      assert_equal Date.today, @shift_ed.date
      assert_equal Date.today, @shift_cindy.date
      assert @job_ed.active == true
      assert @job_cindy.active == false
    end
    
    should "make sure job is active in system" do
      shiftjob_cindy = FactoryGirl.build(:shift_job, :shift => @shift_cindy, :job => @job_cindy)
      deny shiftjob_cindy.valid?
      shiftjob_cindy.destroy
    end
    
    should "allow jobs to be added to shift when shift is over" do
      shiftjob_ed = FactoryGirl.build(:shift_job, :shift => @shift_ed, :job => @job_ed)
      assert shiftjob_ed.valid?
      shiftjob_ed.destroy
    end
   
  end

end
