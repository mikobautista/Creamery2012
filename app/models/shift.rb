class Shift < ActiveRecord::Base

  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :assignment_id, :date, :start_time
  
  # Scopes
  # -----------------------------
  # returns shifts of certain assignment
  scope :for_assignment, lambda {|assignment_id| where("assignment_id = ?", assignment_id) }
  
  # returns shifts in chronological order
  scope :chronological, order('date, start_time, end_time')

end
