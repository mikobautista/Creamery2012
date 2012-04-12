class Shift < ActiveRecord::Base
  
  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs
  has_one :store, :through => :assignment
  has_one :employee, :through => :assignment
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :assignment_id, :date, :start_time
  
  # make sure assignment id is a positive integer
  validates_numericality_of :assignment_id, :only_integer => true, :greater_than => 0

  # ensure start time is before end time and not nil
  validates_time :start_time, :allow_nil => false
  
  # ensure end time is after start time
  validates_time :end_time, :after => :start_time, :allow_nil => true

  # Scopes
  # -----------------------------
  
  # returns shifts in chronological order
  scope :chronological, order('date, start_time, end_time')
  
  # returns all shifts in the system that have at least one job associated with them
  scope :completed, Shift.all.collect{|x| x if x.jobs.count >= 1}
  
  # returns all shifts in the system that have do not have at least one job associated with the
  scope :incomplete, Shift.all.collect{|x| x if x.jobs.count < 1}
  
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
  scope :for_next_days, lambda { |x|  Shift.find(:all, :conditions => [ "date <= ?", Date.today + x] ) }
  
  # returns all the past shifts in the previous 'x' days
  scope :for_past_days, lambda { |x|  Shift.find(:all, :conditions => [ "date <= ?", Date.today + x] ) }

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

end
