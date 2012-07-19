require 'spec_helper'

describe Clieop::Payment::Batch do

  before(:all) do
    @batch_info_without_description = {
      :account_nr    => 123456789,
      :account_owner => "Reciever"
    }
    @batch_info = @batch_info_without_description.merge :description => 'Batch'
  end

  it "should generate valid object" do
    Clieop::Payment::Batch.new(@batch_info.dup).class.should eql(Clieop::Payment::Batch)
  end

  it "should generate a invoice batch" do
    batch = Clieop::Payment::Batch.invoice_batch(@batch_info.dup)
    batch.class.should eql(Clieop::Payment::Batch)
    batch.batch_info[:transaction_group].should eql(10)
  end

  it 'should allow omitting a description' do
    expect {
      Clieop::Payment::Batch.invoice_batch(@batch_info_without_description)
    }.to_not raise_error
  end

  it "should generate a payment batch" do
    batch = Clieop::Payment::Batch.payment_batch(@batch_info.dup)
    batch.class.should eql(Clieop::Payment::Batch)
    batch.batch_info[:transaction_group].should eql(0)
  end

  describe "transactions" do

    describe "Invoice" do

      before do
        @batch = Clieop::Payment::Batch.invoice_batch(@batch_info.dup)
        @transaction = {
          :reference_number => "Factnr 100101",
          :account_nr       => 123456789,
          :account_owner    => 'Payee',
          :account_city     => 'Enschede',          
          :amount           => 30102,
          :description      => "Testing a CLIEOP direct debt transaction\nCharging your bank account",
          :transaction_type => 1001
        }
        @batch << @transaction
      end

      it "should add transactions to batch" do
        @batch.batch_info[:transaction_group].should eql(10)
        @batch.to_clieop.should  match(/0010B1001234567890001EUR                          /)
        @batch.to_clieop.should  match(/0020ABatch                                        /)
        @batch.to_clieop.should  match(/0030B1000000Reciever                           P  /)
        @batch.to_clieop.should  match(/0100A100100000301020001234567890123456789         /)
        @batch.to_clieop.should  match(/0110BPayee                                        /)
        @batch.to_clieop.should  match(/0113BEnschede                                     /)        
        @batch.to_clieop.should  match(/0150AFactnr 100101                                /)
        @batch.to_clieop.should  match(/0160ATesting a CLIEOP direct debt tra             /)
        @batch.to_clieop.should  match(/0160ACharging your bank account                   /)
        @batch.to_clieop.should  match(/9990A00000000000301020002469135780000001          /)
      end

      it 'should omit 0020 record when there is no descroption' do
        batch = Clieop::Payment::Batch.invoice_batch(@batch_info_without_description)
        batch << @transaction
        batch.to_clieop.should_not match(/^0020/)
      end

      it "should appear in proper order" do
        last_record_code = 0
        @batch.to_clieop.split("\n").each do |line|
          line =~ /^(\d{4})[AB]/
          $1.to_i.should >= last_record_code
          last_record_code = $1.to_i
        end
      end

    end

    describe "Payment" do

      before do
        @batch = Clieop::Payment::Batch.payment_batch(@batch_info.dup)
        @transaction = {
          :reference_number => "Factnr 100101",
          :account_nr       => 123456789,
          :account_owner    => 'Payee',
          :account_city     => 'Enschede',     
          :amount           => 30102,
          :description      => "Testing a CLIEOP direct credit transaction\nPaying your bank account",
          :transaction_type => 1001
        }
        @batch << @transaction
      end

      it "should add transactions to batch" do
        @batch.batch_info[:transaction_group].should eql(0)
        @batch.to_clieop.should  match(/0010B0001234567890001EUR                          /)
        @batch.to_clieop.should  match(/0020ABatch                                        /)
        @batch.to_clieop.should  match(/0030B1000000Reciever                           P  /)
        @batch.to_clieop.should  match(/0100A100100000301020001234567890123456789         /)
        @batch.to_clieop.should  match(/0150AFactnr 100101                                /)
        @batch.to_clieop.should  match(/0160ATesting a CLIEOP direct credit t             /)
        @batch.to_clieop.should  match(/0160APaying your bank account                     /)
        @batch.to_clieop.should  match(/0170BPayee                                        /)
        @batch.to_clieop.should  match(/0173BEnschede                                     /)          
        @batch.to_clieop.should  match(/9990A00000000000301020002469135780000001          /)
      end

      it 'should omit 0020 record when there is no descroption' do
        batch = Clieop::Payment::Batch.invoice_batch(@batch_info_without_description)
        batch << @transaction
        batch.to_clieop.should_not match(/^0020/)
      end

      it "should appear in proper order" do
        last_record_code = 0
        @batch.to_clieop.split("\n").each do |line|
          line =~ /^(\d{4})[AB]/
          $1.to_i.should >= last_record_code
          last_record_code = $1.to_i
        end
      end

    end

  end

end
