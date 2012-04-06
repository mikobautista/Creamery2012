class Job < ActiveRecord::Base
  
  # Relationships
  # -----------------------------
  has_many :shift_jobs
  has_many :shifts, :through => :shift_jobs

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :name
  
  # Scopes
  # -----------------------------
  # returns only active jobs
  scope :active, where('active = ?', true)
  
  # returns all inactive jobs
  scope :inactive, where('active = ?', false)
  
  # orders results alphabetically
  scope :alphabetical, order('name')

end