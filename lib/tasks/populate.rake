namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Need two gems to make this work: faker & populator
    # Docs at: http://populator.rubyforge.org/
    require 'populator'
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    
    # Step 0: clear any old data in the db
    [Employee, Assignment, Store].each(&:delete_all)
    
    # Step 1a: Add Alex as admin and user
    ae = Employee.new
    ae.first_name = "Alex"
    ae.last_name = "Heimann"
    ae.ssn = "123456789"
    ae.date_of_birth = "1993-01-25"
    ae.phone = "412-268-3259"
    ae.role = "admin"
    ae.active = true
    ae.save!
    # au = User.new
    # au.email = "alex@example.com"
    # au.password = "creamery"
    # au.password_confirmation = "creamery"
    # au.employee_id = ae.id
    # au.save!
    
    # Step 1b: Add Mark as employee and user
    me = Employee.new
    me.first_name = "Mark"
    me.last_name = "Heimann"
    me.ssn = "987654321"
    me.date_of_birth = "1993-01-25"
    me.phone = "412-268-8211"
    me.active = true
    me.role = "admin"
    me.save!
    # mu = User.new
    # mu.email = "mark@example.com"
    # mu.password = "creamery"
    # mu.password_confirmation = "creamery"
    # mu.employee_id = me.id
    # mu.save!
    
    # Step 2: Add some stores
    stores = {"Carnegie Mellon" => "5000 Forbes Avenue;15213", "Convention Center" => "1000 Fort Duquesne Blvd;15222", "Point State Park" => "101 Commonwealth Place;15222"}
    stores.each do |store|
      str = Store.new
      str.name = store[0]
      street, zip = store[1].split(";")
      str.street = street
      str.city = "Pittsburgh"
      str.zip = zip
      str.phone = rand(10 ** 10).to_s.rjust(10,'0')
      str.active = true
      str.save!
    end
    
    # Step 3: Add two managers for each store
    active_stores = Store.active.each do |store|
      # Add manager 
      2.times do |i|
        mgr = Employee.new
        mgr.first_name = Faker::Name.first_name
        mgr.last_name = Faker::Name.last_name
        mgr.ssn = rand(9 ** 9).to_s.rjust(9,'0')
        mgr.date_of_birth = (rand(9)+20).years.ago.to_date
        mgr.phone = rand(10 ** 10).to_s.rjust(10,'0')
        mgr.active = true
        mgr.role = "manager"
        mgr.save!
        # Assign to store
        assign_mgr = Assignment.new
        assign_mgr.store_id = store.id
        assign_mgr.employee_id = mgr.id
        assign_mgr.start_date = (rand(14)+2).months.ago.to_date
        assign_mgr.end_date = nil
        assign_mgr.pay_level = [4,5].sample
        assign_mgr.save!
      end
    end
    
    # Step 4: Add some employees to the system
    store_ids = Store.all.map(&:id)
    Employee.populate 100 do |employee|
      # get some fake data using the Faker gem
      employee.first_name = Faker::Name.first_name
      employee.last_name = Faker::Name.last_name
      employee.role = "employee"
      employee.ssn = rand(9 ** 9).to_s.rjust(9,'0')
      employee.phone = rand(10 ** 10).to_s.rjust(10,'0')
      employee.date_of_birth = 22.years.ago..15.years.ago
      not_active = rand(5)
      if not_active.zero?
        employee.active = false
      else
        employee.active = true
      end
      employee.created_at = Time.now
      employee.updated_at = Time.now
      
      # Step 5: Add an assignment for each employee
      pay_levels = [1,2,3]
      Assignment.populate 1 do |asn1|
        asn1.employee_id = employee.id
        asn1.store_id = store_ids.sample 
        asn1.pay_level = pay_levels.sample 
        asn1.start_date = 2.years.ago..2.months.ago
        if employee.active
          asn1.end_date = nil
        else
          asn1.end_date = 2.months.ago..2.days.ago
        end
      end
    end
    
    # Step 6: Add another assignment for some employees
    current_assignments = Assignment.current.for_role("employee").all
    current_assignments.each do |first_assignment|
      additional_assignments = rand(4)
      unless additional_assignments.zero?
        Assignment.populate 1 do |asn2|
          asn2.employee_id = first_assignment.employee_id
          asn2.store_id = store_ids.sample
          asn2.pay_level = first_assignment.pay_level + 1
          asn2.start_date = 7.weeks.ago..2.days.ago
          asn2.end_date = nil
        end
      end
    end
  end
end      
