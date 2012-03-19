require 'spec_helper'

describe Clieop::ProcessInfo::Transaction do

  before :all do
    @info_file = Clieop::ProcessInfo::File.from_file(File.open(File.join(File.dirname(__FILE__), '../../files/VERWINFO.txt')), true)    
  end
  
  subject { @info_file.batches.first.transactions.first }
  
  it "should have transaction info" do
    subject.info.except(:euro_record, :reverse_info, :reject_info, :transaction_descriptions, :settle_info).should == { :amount => BigDecimal('0.0'), :from_account=>123071492, :to_account=>123456789, :entry_account=>123456789, :from_account_verification_nr=>nil, :transaction_reference_ok=>nil }
  end
  
  it "should contain transaction info records" do
    info_keys = subject.info.keys
    [:euro_record, :reverse_info, :reject_info, :transaction_descriptions, :settle_info].each do |record_type|
      info_keys.should include record_type
    end
  end

end
