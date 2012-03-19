require 'spec_helper'

describe Clieop::Payment::File do

  context "#save" do

    it "should create 'filename' and put the CLIEOP data in it" do
      file = mock('file')
      File.should_receive(:open).with("filename", "w").and_yield(file)
      file.should_receive(:write).with("0001A#{Date.today.strftime('%d%m%y')}CLIEOP03         1                     \r\n9999A                                             \r\n")
      subject.save('filename')
    end
  end
end
