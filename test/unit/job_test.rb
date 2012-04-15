require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # Test relationships
  # -----------------------------
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)
  
  # Test basic validations
  # -----------------------------
  should validate_presence_of(:name)
  
  # Need to do the rest with a context
  # ---------------------------------
  context "Creating four jobs" do
    # create the objects I want with factories
    setup do
      @active1 = Factory.create(:job, :name => "Active1", :active => true)
      @active2 = Factory.create(:job, :name => "Active2", :active => true)
      @inactive1 = Factory.create(:job, :name => "Inactive1", :active => false)
      @inactive2 = Factory.create(:job, :name => "Inactive2", :active => false)
    end

    # and provide a teardown method as well
    teardown do
      @active1.destroy
      @active2.destroy
      @inactive1.destroy
      @inactive2.destroy
    end

    # test the scope 'active'
    should "shows that there are two active jobs" do
      assert_equal ["Active1", "Active2"], Job.active.map{|o| o.name}
    end
    
    # test the scope 'inactive'
    should "shows that there are two inactive jobs" do
      assert_equal ["Inactive1", "Inactive2"], Job.inactive.map{|o| o.name}
    end
    
    # test the scope 'alphabetical'
    should "shows that jobs are ordered alphabetically" do
      assert_equal ["Active1", "Active2", "Inactive1", "Inactive2"], Job.alphabetical.map{|o| o.name}
    end
    
  end

end
