class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :employee_id, :email, :password_digest

  # Relationships
  # -----------------------------
  belongs_to :employee

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :employee_id, :email, :password_digest

  scope :alphabetical, joins(:employee).order('last_name, first_name')

  #Methods
  # -----------------------------
  # authenticate via email
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
