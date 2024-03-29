class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :employee_id
  attr_accessor :password
  
  # Callbacks
  # -----------------------------
  before_save :prepare_password
  before_create { generate_token(:auth_token) }
  
  # Relationships
  # -----------------------------
  belongs_to :employee

  # Validations
  # -----------------------------
  # email must be unique and in proper format
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  # password must be present and at least 4 characters long, with a confirmation
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  # employee that user is being assigned to must be active in the system
  validate :employee_is_active_in_system
  
  # Scopes
  # -----------------------------
  scope :alphabetical, joins(:employee).order('last_name, first_name')

  # returns the name of the employee the user is assigned to
  def proper_name
    Employee.find(self.employee_id).name 
  end

  # returns the role of the employee the user is assigned to
  def role
    Employee.find(self.employee_id).role
  end

  # Validation Method
  # -----------------------------
  def employee_is_active_in_system
    employee_ids = Employee.active.all.map{|e| e.id}
    unless employee_ids.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee")
      return false
    end
    return true
  end

  # Password-related Methods
  # -----------------------------
  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  private
  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
