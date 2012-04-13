class ShiftJob < ActiveRecord::Base
  before_create :shift_end_time_passed
  
  # Relationships
  # -----------------------------
  belongs_to :shift
  belongs_to :job
  
  # Validations
  # -----------------------------
  validate :shift_end_time_passed

  # Callback Methods
  # -----------------------------
  # make sure shift end time passed before creating
  def shift_end_time_passed
    time_now = Time.now.localtime
    time_start = Shift.find(self.shift_id).start_time.localtime
    time_end = Shift.find(self.shift_id).end_time.localtime
    conv_now = Time.at(time_now.hour * 60 * 60 + time_now.min * 60 + time_now.sec)
    conv_end = Time.at(time_end.hour * 60 * 60 + time_end.min * 60 + time_end.sec)
    conv_start = Time.at(time_start.hour * 60 * 60 + time_start.min * 60 + time_start.sec)
    if conv_now > conv_end || conv_now < conv_start
      return true
    else
      errors.add(:shift_id, "must be after shift has ended, current time is #{time_1}, shift_end is #{time_2}")
      return false
    end
 end
  
  #def shift_end_time_passed
  #  if self.shift.nil? || self.job.nil?
  #    return false
  #  end
  #  if self.shift.end_time < Time.now
  #    errors.add(:job_id, "cannot be added to unfinished shift")
  #  end
  #end  

end
