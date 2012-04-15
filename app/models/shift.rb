class Shift < ActiveRecord::Base
  
  before_create :set_end_time
  
  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs
  has_one :store, :through => :assignment
  has_one :employee, :through => :assignment
  
  accepts_nested_attributes_for :shift_jobs, :reject_if => lambda {|shiftjob| shiftjob[:job_id].blank?}
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :assignment_id, :date, :start_time
  
  # make sure assignment id is a positive integer
  validates_numericality_of :assignment_id, :only_integer => true, :greater_than => 0

  # ensure start time is before end time and not nil
  validates_time :start_time, :allow_nil => false
  
  # ensure end time is nil after creation, and after start time but before current time after updating
  validates_time :end_time, :on => :create, :allow_nil => true, :allow_blank => true
  validates_time :end_time, :on => :update, :after => :start_time, :after_message => "cannot be before/during start time"
  validate :end_time_is_not_in_future, :on => :update
  
  # make sure the assignment selected is one that is active
  validate :assignment_is_current
  
  # Scopes
  # -----------------------------
  # returns all shifts in the system that have at least one job associated with them
  scope :completed, where(:id => ShiftJob.select('shift_id'))
  
  # returns all shifts in the system that have do not have at least one job associated with the
  scope :incomplete, where('shifts.id NOT IN (SELECT shift_id FROM shift_jobs)')
  
  # returns all shifts that are associated with a given store
  scope :for_store, lambda {|store_id| joins(:assignment).where('store_id = ?', store_id) }
  
  # returns all shifts that are associated with a given employee
  scope :for_employee, lambda { |employee_id| joins(:assignment).where('employee_id = ?', employee_id) }

  # returns shifts of certain assignment
  scope :for_assignment, lambda {|assignment_id| where("assignment_id = ?", assignment_id) }
  
  # returns all shifts which have a date in the past
  scope :past, where('date < ?', Date.today)
  
  # returns all shifts which have a date in the present or future
  scope :upcoming, where('date >= ?', Date.today)
  
  # returns all the upcoming shifts in the next 'x' days 
  scope :for_next_days, lambda {|num| where('date >= ? AND date <= ?', Date.current, num.days.from_now.to_date)}
  
  # returns all the past shifts in the previous 'x' days
  scope :for_past_days, lambda {|num| where('date >= ? AND date < ?', num.days.ago.to_date, Date.current)}

  # returns shifts in chronological order
  scope :chronological, order('date')

  # orders values by store  
  scope :by_store, joins(:store).order('name')
  
  # orders values by employee's last, first names
  scope :by_employee, joins(:employee).order('last_name, first_name')

  # Methods
  # -----------------------------
  # returns all shifts which have been assigned to jobs via shiftjobs
  def completed?
    # get an array of all shifts in the shiftjob table
    possible_shift_ids = ShiftJob.all.map{|s| s.id}
    # return true if shift id is in the array
    if possible_shift_ids.include?(self.id)
      return true
    end
    return false
  end
  
  # returns the number of hours that the shift lasted
  def time_worked_in_hours
    return 0 if self.end_time.nil?
    return ((self.end_time.hour * 60 + self.end_time.min) - (self.start_time.hour * 60 + self.start_time.min)) / 60
  end
  
  # return whether or not the end time of the shift is in the future on update
  def end_time_is_not_in_future
    return true if self.end_time.nil?
    if self.date < Date.today
      return true
    elsif self.date == Date.today
      return Time.now.hour * 60 + Time.now.min > self.end_time.hour * 60 + self.end_time.min
    else
      return false
    end
  end
  
  # Private methods used to execute the custom validations
  # -----------------------------
  private
  # returns whether or not the assignment the shift is being assigned to is current
  def assignment_is_current
    # get an array of all employee ids
    possible_assignment_ids = Assignment.current.all.map{|a| a.id}
    # add error unless the employee id is in the array of possible ids
    unless possible_assignment_ids.include?(self.assignment_id)
      errors.add(:assignment_id, "is not a current assignment")
      return false
    end
    return true
  end

  # automatically sets the end time of the shift 3 hours after the start time on update
  def set_end_time
    self.end_time = self.start_time + 3.hours if self.end_time.blank?
  end

end
