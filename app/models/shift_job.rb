class ShiftJob < ActiveRecord::Base
  before_create :shift_end_time_passed
  
  # Relationships
  # -----------------------------
  belongs_to :shift
  belongs_to :job
  
  # Validations
  # -----------------------------
  validate :shift_end_time_passed
  validate :job_is_active_in_system

  # Scopes
  # -----------------------------
  scope :by_job, joins(:job).order('name')
  
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
      errors.add(:shift_id, "cannot still be ongoing.")
      return false
    end
  end
  
  # returns whether or not the job the shiftjob is assigned to is active
  def job_is_active_in_system
    all_active_jobs = Job.active.all.map{|j| j.id}
    unless all_active_jobs.include?(self.job_id)
      errors.add(:job_id, "is not an active job at the creamery")
    end
  end

end
