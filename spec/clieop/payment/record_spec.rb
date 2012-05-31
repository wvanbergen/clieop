require 'spec_helper'

describe Clieop::Payment::Record do

  before(:all) do
  end

  it "should generate :file_header" do
    record = Clieop::Payment::Record.new(:file_header, :date => '050410')
    record.to_clieop.should match(/0001A050410CLIEOP03         1                     /)
  end

  it "should generate :file_footer" do
    record = Clieop::Payment::Record.new(:file_footer)
    record.to_clieop.should match(/9999A                                             /)
  end

  it "should generate :batch_header for direct debit" do
    record = Clieop::Payment::Record.new(:batch_header,
      :transaction_group => 10,
      :acount_nr         => 1234567890,
      :serial_nr         => 1
    )
    record.to_clieop.should match(/0010B1012345678900001EUR                          /)
  end

  it "should generate :batch_header for payment" do
    record = Clieop::Payment::Record.new(:batch_header,
      :transaction_group => 0,
      :acount_nr         => 1234567890,
      :serial_nr         => 1
    )
    record.to_clieop.should match(/0010B0012345678900001EUR                          /)
  end

  # TODO Also do calculations
  it "should generate :batch_footer" do
    record = Clieop::Payment::Record.new(:batch_footer,
      :total_amount      => 0,
      :account_checksum  => 1234567890,
      :tranasction_count => 0
    )
    record.to_clieop.should match(/9990A00000000000000000012345678900000000          /)
  end

  it "should generate :batch_description" do
    record = Clieop::Payment::Record.new(:batch_description,
      :description      => 'Testing a CLIEOP direct debt transaction\nCharging your bank account'
    )
    record.to_clieop.should match(/0020ATesting a CLIEOP direct debt tra             /)
  end

  it "should generate :batch_owner" do
    record = Clieop::Payment::Record.new(:batch_owner,
      :owner => 'Reciever'
    )
    record.to_clieop.should match(/0030B1000000Reciever                           P  /)
  end

  it "should generate :transaction_info" do
    record = Clieop::Payment::Record.new(:transaction_info,
      :amount       => 'Reciever',
      :from_account => 1234567890,
      :to_account   => 1234567890
    )
    record.to_clieop.should match(/0100A100200000000000012345678901234567890         /)
  end

  it "should generate :invoice_name" do
    record = Clieop::Payment::Record.new(:invoice_name,
      :name => 'Payee'
    )
    record.to_clieop.should match(/0110BPayee                                        /)
  end
  
  it "should generate :invoice_city" do
    record = Clieop::Payment::Record.new(:invoice_city,
      :city => 'Enschede'
    )
    record.to_clieop.should match(/0113BEnschede                                     /)
  end   

  it "should generate :payment_name" do
    record = Clieop::Payment::Record.new(:payment_name,
      :name => 'Reciever'
    )
    record.to_clieop.should match(/0170BReciever                                     /)
  end
  
  it "should generate :payment_city" do
    record = Clieop::Payment::Record.new(:payment_city,
      :city => 'Enschede'
    )
    record.to_clieop.should match(/0173BEnschede                                     /)
  end  

  it "should generate :transaction_reference" do
    record = Clieop::Payment::Record.new(:transaction_reference,
      :reference_number => '201000505'
    )
    record.to_clieop.should match(/0150A201000505                                    /)
  end

  it "should generate :transaction_description" do
    record = Clieop::Payment::Record.new(:transaction_description,
      :description => 'Automatic Invoice Transaction'
    )
    record.to_clieop.should match(/0160AAutomatic Invoice Transaction                /)
  end

end
