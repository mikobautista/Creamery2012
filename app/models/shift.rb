class Shift < ActiveRecord::Base
  
  # create a callback that will call set_end_time before create
  before_create :set_end_time
  
  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :assignment_id, :date, :start_time
  
  # ensure end time is after start time and not in the future
  validates_time :end_time, :after => :start_time, :on_or_before => lambda { Time.current }, :allow_blank => true
  
  # make sure the assignment selected is one that is active
  validate :assignment_is_active_in_system
  
  # Scopes
  # -----------------------------
  # returns shifts of certain assignment
  scope :for_assignment, lambda {|assignment_id| where("assignment_id = ?", assignment_id) }
  
  # returns shifts in chronological order
  scope :chronological, order('date, start_time, end_time')
  
  # returns all shifts in the system that have at least one job associated with them
  scope :completed, joins(:shiftjobs).where('job_id IS NOT NULL')
  
  # returns all shifts in the system that have do not have at least one job associated with the
  scope :incomplete, joins(:shiftjobs).where('job_id IS NULL')
  
  # returns all shifts that are associated with a given store
  scope :for_store, lambda {|store_id| where("store_id = ?", store_id) }
  
  # returns all shifts that are associated with a given employee
  scope :for_employee, lambda {|employee_id| where("employee_id = ?", employee_id) }
  
  # returns all shifts which have a date in the past
  scope :past, where("date < ?", Date.today)
  
  # returns all shifts which have a date in the present or future
  scope :upcoming, where("date >= ?", Date.today)
  
  # returns all the upcoming shifts in the next 'x' days 
  scope :for_next_days, lambda {|x| where("date >= ? AND date <= ?", Date.today, Date.today + x.days) }
  
  # returns all the past shifts in the previous 'x' days
  scope :for_past_days, lambda {|x| where("date <= ? AND date >= ?", Date.today, Date.today - x.days) }

  # orders values by store  
  scope :by_store, joins(:store).order('name')
  
  # orders values by employee's last, first names
  scope :by_employee, joins(:employee).order('last_name, first_name')
  
  # Methods
  # -----------------------------
  def completed?
    # get an array of all shifts in the shiftjob table
    possible_shift_ids = ShiftJob.all.shift_id.map{|s| s.id}
    # return true if shift id is in the array
    if possible_shift_ids.contains(self.id)
      return true
    end
  end
  
  # Callback Methods
  # -----------------------------
  private
  def set_end_time
    self.end_time = self.start_time + 3.hours
  end

  # Private methods used to execute the custom validations
  # -----------------------------
  private
  def assignment_is_active_in_system
    # get an array of all assignment ids
    possible_assignment_ids = Assignment.active.all.map{|a| a.id}
    # add error unless the assignment id is in the array of possible ids
    unless possible_assignment_ids.include?(self.assignment_id)
      errors.add(:assignment_id, "is not an active assignment")
      return false
    end
    return true
  end
  
end
