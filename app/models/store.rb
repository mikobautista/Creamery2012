class Store < ActiveRecord::Base
  # Callbacks
  before_save :reformat_phone
  before_save :find_store_coordinates
  
  # Relationships
  has_many :assignments
  has_many :employees, :through => :assignments
  has_many :shifts, :through => :assignments
  
  # Validations
  # make sure required fields are present
  validates_presence_of :name, :street, :city
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option"
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # make sure stores have unique names
  validates_uniqueness_of :name
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  
  def employee_hours
    num_hours = 0
    self.employees.each do |employee|
      num_hours += employee.assignment_hours
    end
    return num_hours
  end
  
  def find_store_coordinates
    coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{name}, #{state}"
    if coord.success
      self.lat, self.lon = coord.ll.split(',')
    else
      errors.add_to_base("Error with geocoding")
    end
  end
  
  
  # Callback code
  # -----------------------------
  
  private
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  

end

