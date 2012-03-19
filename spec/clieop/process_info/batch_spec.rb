require 'spec_helper'

describe Clieop::ProcessInfo::Batch do

  before :all do
    @info_file = Clieop::ProcessInfo::File.from_file(File.open(File.join(File.dirname(__FILE__), '../../files/VERWINFO.txt')), true)    
  end
  
  subject { @info_file.batches.first }
  
  it "should add batch info to batches" do
    subject.info.should == {:account_nr=>123456789, :total_amount=>nil, :transaction_count=>9, :test_code=>"T", :batch_type=>"A", :period_type=>nil, :period_length=>nil, :period_nr=>nil, :currency=>"EUR", :batch_identifier=>nil, :total_rejected=>9, :total_reversed=>0}
  end
  
  it "should have several transactions" do
    subject.transactions.should have(9).things
  end
  
  it "should add records to the current transaction info" do
    info_keys = subject.transactions.first.info.keys
    [:euro_record, :reverse_info, :reject_info, :transaction_descriptions, :settle_info].each do |record_type|
      info_keys.should include record_type
    end
  end

end
