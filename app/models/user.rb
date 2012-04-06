class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :employee_id, :email, :password_digest
  before_create :employee_is_active_in_system

  # Relationships
  # -----------------------------
  belongs_to :employee
  has_many :assignments, :through => :employees
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :employee_id, :email, :password_digest

  # make sure emails are unique among employees
  validates_uniqueness_of :email
  
  # Methods
  # -----------------------------
  # authenticate via email
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  # Callback Methods
  # -----------------------------
  private
  def employee_is_active_in_system
    # get an array of all employee ids
    possible_employee_ids = Employee.active.all.map{|e| e.id}
    # add error unless the employee id is in the array of possible ids
    unless possible_employee_ids.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee")
      return false
    end
    return true
  end
  
end
