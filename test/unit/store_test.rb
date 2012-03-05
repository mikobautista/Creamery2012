require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)
  
  # Test basic validations
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)
  # tests for zip
  should allow_value("15213").for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)
  # tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value("NY").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  
  # Establish context
  # Testing other methods with a context
  context "Creating three stores" do
    # create the objects I want with factories
    setup do 
      @cmu = FactoryGirl.create(:store)
      @hazelwood = FactoryGirl.create(:store, :name => "Hazelwood", :active => false)
      @oakland = FactoryGirl.create(:store, :name => "Oakland", :phone => "412-268-8211")
    end
    
    # and provide a teardown method as well
    teardown do
      @cmu.destroy
      @hazelwood.destroy
      @oakland.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert @oakland.active
      deny @hazelwood.active
    end
    
    # test stores must have unique names
    should "force stores to have unique names" do
      repeat_store = Factory.build(:store, :name => "CMU")
      deny repeat_store.valid?
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Oakland's phone is stripped of non-digits" do
      assert_equal "4122688211", @oakland.phone
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three stores in in alphabetical order" do
      assert_equal ["CMU", "Hazelwood", "Oakland"], Store.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "Oakland"], Store.active.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive store" do
      assert_equal 1, Store.inactive.size
      assert_equal ["Hazelwood"], Store.inactive.alphabetical.map{|s| s.name}
    end
    
  end
end
