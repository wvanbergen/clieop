require 'spec_helper'

describe Clieop::Batch do

  before(:all) do
    @batch_info = {
      :description   => "Batch",
      :account_nr    => 123456789,
      :account_owner => "Reciever"
    }
  end

  it "should generate valid object" do
    Clieop::Batch.new(@batch_info.dup).class.should eql(Clieop::Batch)
  end

  it "should generate a invoice batch" do
    batch = Clieop::Batch.invoice_batch(@batch_info.dup)
    batch.class.should eql(Clieop::Batch)
    batch.batch_info[:transaction_group].should eql(10)
  end

  it "should generate a payment batch" do
    batch = Clieop::Batch.payment_batch(@batch_info.dup)
    batch.class.should eql(Clieop::Batch)
    batch.batch_info[:transaction_group].should eql(0)
  end

  describe "transactions" do

    describe "Invoice" do

      before do
        @batch = Clieop::Batch.invoice_batch(@batch_info.dup)
        @batch << {
          :reference_number => "Factnr 100101",
          :account_nr       => 123456789,
          :account_owner    => 'Payee',
          :amount           => 30102,
          :description      => "Testing a CLIEOP direct debt transaction\nCharging your bank account",
          :transaction_type => 1001
        }
      end

      it "should add transactions to batch" do
        @batch.batch_info[:transaction_group].should eql(10)
        @batch.to_clieop.should  match(/0010B1001234567890001EUR                          /)
        @batch.to_clieop.should  match(/0020ABatch                                        /)
        @batch.to_clieop.should  match(/0030B1000000Reciever                           P  /)
        @batch.to_clieop.should  match(/0100A100100000301020001234567890123456789         /)
        @batch.to_clieop.should  match(/0110BPayee                                        /)
        @batch.to_clieop.should  match(/0150AFactnr 100101                                /)
        @batch.to_clieop.should  match(/0160ATesting a CLIEOP direct debt tra             /)
        @batch.to_clieop.should  match(/0160ACharging your bank account                   /)
        @batch.to_clieop.should  match(/9990A00000000000301020002469135780000001          /)
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
