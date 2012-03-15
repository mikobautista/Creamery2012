module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #

  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /my account page/
      edit_user_path(@alex)


    # stores
    when /my stores page/
      stores_path
  
    when /the new store page/
      new_store_path
  
    when /ACAC details page/
      store_path(@acac)
  
    when /CMU details page/
      store_path(@cmu)


    # employees
    when /my employees page/
      employees_path
  
    when /the new employee page/
      new_employee_path
  
    when /details on Jon Hersh/
      employee_path(@hersh)
  
    when /details on Stafford Brunk/
      employee_path(@brunk)
  
    when /details on Evan Schell/
      employee_path(@schell)

    when /details on Taylor Olbeter/
      employee_path(@taylor)


    # assignments
    when /assignments index page/
      assignments_path

    when /the new assignment page/
      new_assignment_path

    when /this assignment details page/
      assignment_path(Assignment.last)

    when /details on the Brunk assignment/
      assignment_path(@brunk_assign)
    
    when /details on the Daigle assignment/
      assignment_path(@daigle_assign)
      
    
    # Semi-static pages
    when /the About Us page/
      about_path
      
    when /the Contact Us page/
      contact_path
      
    when /the Privacy page/
      privacy_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
