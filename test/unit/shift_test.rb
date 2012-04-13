require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Test relationships
   should belong_to(:assignment)
   should have_many(:shift_jobs)
   should have_many(:jobs).through(:shift_jobs)
   should have_one(:store).through(:assignment)
   should have_one(:employee).through(:assignment)

  # Test basic validations
  # for assignment id
   should allow_value(1).for(:assignment_id)
   should allow_value(2).for(:assignment_id)
   should allow_value(3).for(:assignment_id)
   should allow_value(4).for(:assignment_id)
   should allow_value(5).for(:assignment_id)
   should allow_value(6).for(:assignment_id)
   should_not allow_value("bad").for(:assignment_id)
   should_not allow_value(0).for(:assignment_id)
   should_not allow_value(2.5).for(:assignment_id)
   should_not allow_value(-2).for(:assignment_id)
  # for date
   should allow_value(7.weeks.ago.to_date).for(:date)
   should allow_value(2.years.ago.to_date).for(:date)
   should_not allow_value("bad").for(:date)
   should_not allow_value(nil).for(:date)
  # for start time
   should allow_value(Time.now).for(:start_time)
   should allow_value(4.hours.ago).for(:start_time)
   should allow_value(3.hours.ago).for(:start_time)
   should_not allow_value(nil).for(:start_time)

  context "Creating three shifts" do
    # create the objects I want with factories
    setup do 
      @cmu = FactoryGirl.create(:store)
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu, :end_date => nil)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :end_date => nil)
      @shift_ed1 = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => 2.weeks.ago.to_date, :start_time => Time.local(2000,1,1,10,0,0), :end_time => Time.local(2000,1,1,12,0,0))
      @shift_ed2 = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => Date.today, :start_time => Time.local(2000,1,1,10,0,0), :end_time => Time.local(2000,1,1,12,0,0))
      @shift_cindy = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => 5.days.from_now.to_date, :start_time => Time.local(2000,1,1,10,0,0), :end_time => Time.local(2000,1,1,12,0,0))
      @job_ed = FactoryGirl.create(:job, :name => "Ed's job name", :description => "Ed's job description", :active => true)
      @shiftjob_ed = FactoryGirl.create(:shift_job, :shift => @shift_ed1, :job => @job_ed)
    end
=begin
    # and provide a teardown method as well
     teardown do
      @cmu.destroy
      @ed.destroy
      @cindy.destroy
      @assign_ed.destroy
      @assign_cindy.destroy
      @shift_ed.destroy
      @shift_cindy.destroy
     end
=end
  
    # now run the tests:
     should "have all the shifts listed chronologically by date" do
       assert_equal [@shift_ed1, @shift_ed2, @shift_cindy], Shift.chronological.map{|s| s}
     end
     
     # test scope completed
     should "show that there is one completed shift" do
      s = Shift.completed.map{|o| o}
      assert_equal 1, s.size
     end
      
     # test scope incomplete
     should "show that there are two incomplete shifts" do
      s = Shift.incomplete.map{|o| o}
      assert_equal 2, s.size
     end
     
     should "have a scope 'for_store' that works" do
       assert_equal 3, Shift.for_store(@cmu.id).size
     end
     
     should "have a scope 'for_employee' that works" do
       assert_equal 2, Shift.for_employee(@ed.id).size
       assert_equal 1, Shift.for_employee(@cindy.id).size
     end
      
     should "have a scope 'for_assignment' that works" do
       assert_equal 2, Shift.for_assignment(@assign_ed.id).size
       assert_equal 1, Shift.for_assignment(@assign_cindy.id).size
     end
     
     should "have a scope to find all past shifts for a store or employee" do
       assert_equal 1, Shift.past.for_store(@cmu.id).size
       assert_equal 1, Shift.past.for_employee(@ed.id).size
       assert_equal 0, Shift.past.for_employee(@cindy.id).size
     end
     
     should "have a scope to find all upcoming shifts for a store or employee" do
       assert_equal 2, Shift.upcoming.for_store(@cmu.id).size
       assert_equal 1, Shift.upcoming.for_employee(@ed.id).size
       assert_equal 1, Shift.upcoming.for_employee(@cindy.id).size
     end
     
     should "have a scope to find all shifts for the next x days" do
       assert_equal 2, Shift.for_next_days(5).size
     end
     
     should "have a scope to find all shifts for the past x days" do
       assert_equal 1, Shift.for_past_days(14).size
     end
     
     should "have all the shifts listed by store" do
       assert_equal [@shift_ed1, @shift_ed2, @shift_cindy], Shift.by_store.map{|s| s}
     end
     
     should "have all the shifts listed by employee" do
       assert_equal [@shift_cindy, @shift_ed1, @shift_ed2], Shift.by_employee.map{|s| s}
     end
     
    # test the method 'completed?'
     should "return whether or not shift is completed" do
      assert_equal true, @shift_ed1.completed?
      assert_equal false, @shift_ed2.completed?
      assert_equal false, @shift_cindy.completed?
     end
     
     should "allow for an end time in the past (or today) but after the start date" do
       # Note that we've been testing :end_date => nil for a while now so safe to assume works...
       @shift_ed3 = FactoryGirl.build(:shift, :assignment => @assign_ed, :date => 2.weeks.ago.to_date, :start_time => Time.local(2000,1,1,10,0,0), :end_time => Time.local(2000,1,1,12,0,0))
       assert @shift_ed3.valid?
     end
     
  end
end



