require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Test relationships
   should belong_to(:assignment)
   should have_many(:jobshifts)
   should have_many(:jobs).through(:shiftjobs)
   
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
   should_not allow_value(1.week.from_now.to_date).for(:date)
   should_not allow_value("bad").for(:date)
   should_not allow_value(nil).for(:date)
  # for start time
   should allow_value(Time.now).for(:start_time)
   should allow_value(4.hours.ago).for(:start_time)
   should allow_value(3.hours.ago).for(:start_time)
   should_not allow_value(1.hour.from_now).for(:start_time)
   should_not allow_value("bad").for(:start_time)
   should_not allow_value(nil).for(:start_time)
  # for end time
   should allow_value(Time.now).for(:end_time)
   should allow_value(4.hours.ago).for(:end_time)
   should allow_value(1.hour.ago).for(:end_time)
   should allow_value(nil).for(:end_time)
   should_not allow_value(1.hour.from_now).for(:end_time)
   should_not allow_value("bad").for(:end_time)
end
