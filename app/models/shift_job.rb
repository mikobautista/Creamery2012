class ShiftJob < ActiveRecord::Base
  before_create :shift_end_time_passed
  
  # Relationships
  # -----------------------------
  belongs_to :shift
  belongs_to :job
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :shift_id, :job_id


  # Callback Methods
  # -----------------------------
  # make sure shift end time passed before creating
  def shift_end_time_passed
    if self.shift_id.end_time < Time.now
      errors.add(:job_id, "cannot be added to unfinished shift")
    end
  end  

end
