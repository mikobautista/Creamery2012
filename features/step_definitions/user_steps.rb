# GIVENS

Given /^an initial business$/ do
  # Stores
  @cmu = FactoryGirl.create(:store)
  @convention = FactoryGirl.create(:store, :name => "Convention Center", :street => "1000 Fort Duquesne Blvd", :zip => "15222")
  @acac = FactoryGirl.create(:store, :name => "ACAC", :street => "250 East Ohio", :zip => "15212")
  @hazelwood = FactoryGirl.create(:store, :name => "Hazelwood", :active => false)
  
  # Employees
  @ed = FactoryGirl.create(:employee)
  @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
  @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :date_of_birth => 17.years.ago.to_date) # active, but unassigned
  @ben = FactoryGirl.create(:employee, :first_name => "Ben", :last_name => "Sisko", :role => "manager", :phone => "412-268-2323")
  @kathryn = FactoryGirl.create(:employee, :first_name => "Kathryn", :last_name => "Janeway", :role => "manager", :date_of_birth => 30.years.ago.to_date)
  @alex = FactoryGirl.create(:employee, :first_name => "Alex", :last_name => "Heimann", :role => "admin")
  @hersh = Factory.create(:employee, :first_name => "Jon", :last_name => "Hersh", :ssn => "234567890", :phone => "4122683259", :role => "manager", :date_of_birth => 27.years.ago.to_date, :active => false)
  @rubinstein = Factory.create(:employee, :first_name => "Ari", :last_name => "Rubinstein", :ssn => "234567891", :phone => "4122683258", :role => "manager", :date_of_birth => 25.years.ago.to_date, :active => false)
  @brunk = Factory.create(:employee, :first_name => "Stafford", :last_name => "Brunk", :ssn => "234567892", :phone => "4122683257", :role => "manager", :date_of_birth => 23.years.ago.to_date)
  @ashton = Factory.create(:employee, :first_name => "Gina", :last_name => "Ashton", :date_of_birth => 229.months.ago.to_date)
  @lin = Factory.create(:employee, :first_name => "Glen", :last_name => "Lin", :date_of_birth => 245.months.ago.to_date)
  @porter = Factory.create(:employee, :first_name => "David", :last_name => "Porter", :ssn => "345678901", :phone => "7243694550", :date_of_birth => 209.months.ago.to_date)
  @holt = Factory.create(:employee, :first_name => "Peter", :last_name => "Holt", :ssn => "456789012", :phone => "4122683692", :date_of_birth => 219.months.ago.to_date)
  @schell = Factory.create(:employee, :first_name => "Evan", :last_name => "Schell", :ssn => "567890123", :phone => "4122684209", :date_of_birth => 239.months.ago.to_date)
  @miller = Factory.create(:employee, :first_name => "Stephen", :last_name => "Miller", :ssn => "678901234", :phone => "4122685502", :date_of_birth => 22.years.ago.to_date)
  @davis = Factory.create(:employee, :first_name => "Jeremy", :last_name => "Davis", :ssn => "789012345", :phone => "7243649946", :date_of_birth => 200.months.ago.to_date)
  @daigle = Factory.create(:employee, :first_name => "Johnny", :last_name => "Daigle", :ssn => "890123456", :phone => "7242372621", :date_of_birth => 217.months.ago.to_date)
  @olbeter = Factory.create(:employee, :first_name => "Amanda", :last_name => "Olbeter", :ssn => "901234567", :phone => "7244234388", :date_of_birth => 218.months.ago.to_date)
  @wakeley = Factory.create(:employee, :first_name => "Heather", :last_name => "Wakeley", :ssn => "012345678", :phone => "7243692531", :date_of_birth => 197.months.ago.to_date)
  @taylor = Factory.create(:employee, :first_name => "Taylor", :last_name => "Olbeter", :ssn => "098765432", :phone => "7244234388", :date_of_birth => 196.months.ago.to_date)

  # Assignments
  @hersh_assign = Factory.create(:assignment, :employee => @hersh, :store => @cmu, :start_date => 3.years.ago.to_date, :end_date => 2.year.ago.to_date, :pay_level => 4)
  @rubinstein_assign = Factory.create(:assignment, :employee => @rubinstein, :store => @cmu, :start_date => 2.years.ago.to_date, :end_date => 1.year.ago.to_date, :pay_level => 5)
  @brunk_assign = Factory.create(:assignment, :employee => @brunk, :store => @cmu, :start_date => 1.years.ago.to_date, :end_date => nil, :pay_level => 5)
  @ashton_assign = Factory.create(:assignment, :employee => @ashton, :store => @cmu, :start_date => 18.months.ago.to_date, :end_date => nil, :pay_level => 3)
  @lin_assign = Factory.create(:assignment, :employee => @lin, :store => @cmu, :start_date => 14.months.ago.to_date, :end_date => nil, :pay_level => 2)
  @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu) # ended a month ago
  @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :start_date => 14.months.ago.to_date, :end_date => nil)

  @assign_ben = FactoryGirl.create(:assignment, :employee => @ben, :store => @acac, :start_date => 2.years.ago.to_date, :end_date => 6.months.ago.to_date, :pay_level => 3)
  @promote_ben = FactoryGirl.create(:assignment, :employee => @ben, :store => @acac, :start_date => 6.months.ago.to_date, :end_date => nil, :pay_level => 4)
  @davis_assign = Factory.create(:assignment, :employee => @davis, :store => @acac, :start_date => 16.months.ago.to_date, :end_date => nil, :pay_level => 1)
  @daigle_assign = Factory.create(:assignment, :employee => @daigle, :store => @acac, :start_date => 50.years.ago.to_date, :end_date => nil, :pay_level => 3)
  @olbeter_assign = Factory.create(:assignment, :employee => @olbeter, :store => @acac, :start_date => 49.months.ago.to_date, :end_date => nil, :pay_level => 1)
  @wakeley_assign = Factory.create(:assignment, :employee => @wakeley, :store => @acac, :start_date => 27.months.ago.to_date, :end_date => 5.weeks.ago.to_date, :pay_level => 2)
  @taylor_assign = Factory.create(:assignment, :employee => @taylor, :store => @acac, :end_date => nil, :pay_level => 2)
  
  @assign_kathryn = FactoryGirl.create(:assignment, :employee => @kathryn, :store => @convention, :start_date => 10.months.ago.to_date, :end_date => nil, :pay_level => 3)
  @porter_assign = Factory.create(:assignment, :employee => @porter, :store => @convention, :start_date => 16.months.ago.to_date, :end_date => nil, :pay_level => 1)
  @holt_assign = Factory.create(:assignment, :employee => @holt, :store => @convention, :end_date => nil, :pay_level => 1)
  @schell_assign = Factory.create(:assignment, :employee => @schell, :store => @convention, :start_date => 4.years.ago.to_date, :end_date => nil, :pay_level => 3)
  @miller_assign = Factory.create(:assignment, :employee => @miller, :store => @convention, :start_date => 2.years.ago.to_date, :end_date => 2.months.ago.to_date, :pay_level => 2)
  
end
