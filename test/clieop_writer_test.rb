require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/clieop.rb"

class ClieopWriterTest < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  
  def test_basic_invoice_usage
    file = Clieop::File.new
    file.invoice_batch({:description => 'some description', :account_nr => 123, :account_owner => 'me'}) do |batch|
      
      batch << { :account_nr => 123456, :account_owner => 'you', :amount => 133.0, 
                 :description => "Testing a CLIEOP direct debt transaction\nCharging your bank account" }
                 
      batch << { :account_nr => 654321, :account_owner => 'somebody else', :amount => 233.0,
                 :description => 'Some description for the other guy' }
                 
    end
    
    clieop_data = file.to_clieop
    
    #TODO: more tests
    assert_kind_of String, clieop_data
    
  end
  
end