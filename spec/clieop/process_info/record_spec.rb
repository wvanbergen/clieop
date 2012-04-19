require 'spec_helper'

describe Clieop::ProcessInfo::Record do

  subject { Clieop::ProcessInfo::Record.new('1000000000000000012307149201234567890123456789') }  

  it "should generate a hash of record codes to types" do
    Clieop::ProcessInfo::Record::TYPE_FOR_RECORD_CODE.keys.should =~ [10, 990, 50, 51, 950, 100, 101, 105, 110, 115, 500, 503, 505, 510, 515, 600]
  end
  
  it "should parse alpha values" do
    Clieop::ProcessInfo::Record.parse_alpha_value('test').should == 'test'    
    Clieop::ProcessInfo::Record.parse_alpha_value('   test   ').should == 'test'
  end
  
  it "should parse numeric values" do
    Clieop::ProcessInfo::Record.parse_numeric_value('000100').should == 100
  end

  it "should parse date values" do
    Clieop::ProcessInfo::Record.parse_date_value('120304').should == Time.parse('120304').to_date   
  end
  
  it "should properly parse the record line and set record attributes" do
    subject.raw_line.should == '1000000000000000012307149201234567890123456789'
    subject.type.should == :transaction_info
    subject.definition.should == Clieop::ProcessInfo::Record::TYPE_DEFINITIONS[:transaction_info]
    subject.data == {:record_code=>100, :amount=>0, :from_account=>123071492, :to_account=>123456789, :entry_account=>123456789, :from_account_verification_nr=>0, :transaction_reference_ok=>nil}
  end
  

end
