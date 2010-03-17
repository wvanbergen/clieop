require File.dirname(__FILE__) + '/spec_helper'

require 'clieop'

describe Clieop do

  it "should test basic invoice usage" do

    file = Clieop::File.new

    file.invoice_batch({:description => 'some description', :account_nr => 123, :account_owner => 'me'}) do |batch|

      batch << { :account_nr => 123456, :account_owner => 'you', :amount => 133.0,
                 :description => "Testing a CLIEOP direct debt transaction\nCharging your bank account" 
               }

      batch << { :account_nr => 654321, :account_owner => 'somebody else', :amount => 233.0,
                 :description => 'Some description for the other guy' }

    end

    clieop_data = file.to_clieop

    clieop_data.class.should  eql(String)

  end

  it "should format the checksum" do
    batch = Clieop::Batch.new({:description => "Description", :account_nr => "Account Nr", :account_owner => "Account Owner" } )
    batch.account_checksum('1234567890123').should  eql('4567890123')
    batch.account_checksum('7654321').should  eql('7654321')
  end

  #TODO: more tests

end