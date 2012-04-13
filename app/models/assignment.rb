class Assignment < ActiveRecord::Base
  # Callbacks
  before_create :end_previous_assignment
  
  # Relationships
  belongs_to :employee
  belongs_to :store
  has_many :shifts
  
  # Validations
  validates_numericality_of :pay_level, :only_integer => true, :greater_than => 0, :less_than => 7
  validates_date :start_date, :on_or_before => lambda { Date.current }, :on_or_before_message => "cannot be in the future"
  validates_date :end_date, :after => :start_date, :on_or_before => lambda { Date.current }, :allow_blank => true
  validate :employee_is_active_in_system
  validate :store_is_active_in_system
  
  # Scopes
  scope :current, where('end_date IS NULL')
  scope :past, where('end_date IS NOT NULL')
  scope :by_store, joins(:store).order('name')
  scope :by_employee, joins(:employee).order('last_name, first_name')
  scope :chronological, order('start_date, end_date')
  scope :for_store, lambda {|store_id| where("store_id = ?", store_id) }
  scope :for_employee, lambda {|employee_id| where("employee_id = ?", employee_id) }
  scope :for_pay_level, lambda {|pay_level| where("pay_level = ?", pay_level) }
  scope :for_role, lambda {|role| joins(:employee).where("role = ?", role) }

  def name
    "#{self.employee.name} @ #{self.store.name}"
  end
  
  def shift_hours
    num_hours = 0
    self.shifts.for_past_days(14).each do |shift|
      num_hours += shift.time_worked_in_hours
    end
    return num_hours
  end
  
  # Private methods for callbacks and custom validations
  private  
  
  def end_previous_assignment
    current_assignment = Employee.find(self.employee_id).current_assignment
    if current_assignment.nil?
      return true 
    else
      current_assignment.update_attribute(:end_date, self.start_date.to_date)
    end
  end
  
  # Again, these are not DRY (...but AM section people should be thinking of how to clean this up)
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee at the creamery")
    end
  end
  
  def store_is_active_in_system
    all_active_stores = Store.active.all.map{|s| s.id}
    unless all_active_stores.include?(self.store_id)
      errors.add(:store_id, "is not an active store at the creamery")
    end
  end
  
end
