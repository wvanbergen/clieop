require 'spec_helper'

describe Clieop::ProcessInfo::File do

  before :each do
    @verwinfo_file = File.open(File.join(File.dirname(__FILE__), '../../files/VERWINFO.txt'))
  end

  subject { Clieop::ProcessInfo::File.from_file(@verwinfo_file, true) }  

  it "should accept a VERWINFO file" do
    subject.records.should_not be_empty
  end
  
  it "should accept a VERWINFO string" do
    Clieop::ProcessInfo::File.from_string(@verwinfo_file.read).records.should_not be_empty
  end
  
  it "should parse file info" do
    subject.info.should == {:filename=>"VERWINFO", :file_version=>"4.1", :date=> Time.parse('101015').to_date, :run_number=>4432, :account_nr=>123456789, :serial_nr=>2, :file_nr=>1, :batches_count=>1, :next_file_nr=>0 }
  end
  
  it "should parse records" do
    subject.records.should have(96).things # 96 lines + 1 EOS char
  end
  
  it "should parse batches" do
    subject.batches.should have(2).things
  end
  
  it "should throw an error when no data can be parsed" do
    lambda { Clieop::ProcessInfo::File.from_string('invalid data') }.should raise_error(RuntimeError, 'No valid records found in VERWINFO data')
  end  

end
