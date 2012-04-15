class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :email, :password, :password_confirmation, :employee_id

  attr_accessor :password
  before_save :prepare_password
  
  # Relationships
  belongs_to :employee

  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validate :employee_is_active_in_system
  
  # Scopes
  scope :alphabetical, joins(:employee).order('last_name, first_name')

  def proper_name
    Employee.find(self.employee_id).name 
  end

  def role
    Employee.find(self.employee_id).role
  end

  # Validation Method
  def employee_is_active_in_system
    employee_ids = Employee.active.all.map{|e| e.id}
    unless employee_ids.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee")
      return false
    end
    return true
  end

  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
