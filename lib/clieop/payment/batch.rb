module Clieop
  module Payment
    
    class Batch

      attr_accessor :transactions, :batch_info

      def initialize(batch_info)
        raise "Required: :description, :account_nr, :account_owner" unless ([:description, :account_nr, :account_owner] - batch_info.keys).empty?
        @transactions = []
        @batch_info = batch_info
      end

      # Adds a transaction to the batch
      #
      # :amount The amount involved with this transaction
      # :account_nr The bank account from the other party
      # :account_owner The name of the owner of the bank account
      # :reference_number A reference number to identify this transaction
      # :description A description for this transaction (4 lines max)
      def add_transaction (transaction)
        raise "No :account_nr given"    if transaction[:account_nr].nil?
        raise "No :amount given"        if transaction[:amount].nil?
        raise "No :account_owner given" if transaction[:account_owner].nil?
        @transactions << transaction
      end

      alias_method :<<, :add_transaction

      def to_clieop

        # generate batch header records
        batch_data = ""
        batch_data << Clieop::Payment::Record.new(:batch_header,
                          :transaction_group => @batch_info[:transaction_group] || 0,
                          :acount_nr         => @batch_info[:account_nr] || 0,
                          :serial_nr         => @batch_info[:serial_nr] || 1,
                          :currency          => @batch_info[:currency] || "EUR").to_clieop

        batch_data << Clieop::Payment::Record.new(:batch_description, :description => @batch_info[:description]).to_clieop
        batch_data << Clieop::Payment::Record.new(:batch_owner,
                          :process_date => @batch_info[:process_date] || 0,
                          :owner        => @batch_info[:account_owner]).to_clieop

        # initialize checksums
        total_account = @batch_info[:account_nr].to_i * @transactions.length
        total_amount  = 0

        # add transactions to batch
        @transactions.each do |tr|

          # prepare data for this transaction's records
          transaction_type = tr[:transaction_type] || (transaction_is_payment? ? 1002 : 0)
          to_account       = transaction_is_payment? ? @batch_info[:account_nr] : tr[:account_nr]
          from_account     = transaction_is_payment? ? tr[:account_nr] : @batch_info[:account_nr]
          amount_in_cents  = (tr[:amount] * 100).round.to_i

          # update checksums
          total_account += tr[:account_nr].to_i
          total_amount  += amount_in_cents

          # generate transaction record
          batch_data << Clieop::Payment::Record.new(:transaction_info,
                            :transaction_type => transaction_type, :amount       => amount_in_cents,
                            :to_account       => to_account,       :from_account => from_account).to_clieop

          # generate record with transaction information
          batch_data << Clieop::Payment::Record.new(:invoice_name, :name => tr[:account_owner]).to_clieop if transaction_is_payment?
          batch_data << Clieop::Payment::Record.new(:transaction_reference, :reference_number => tr[:reference_number]).to_clieop unless tr[:reference_number].nil?

          # split discription into lines and make a record for the first 4 lines
          unless tr[:description].nil? || tr[:description] == ''
            tr[:description].split(/\r?\n/)[0, 4].each do |line| # FIXME raise warning when line is longer than 32 chars/description longer than 4 lines
              batch_data << Clieop::Payment::Record.new(:transaction_description, :description => line.strip).to_s unless line == ''
            end
          end
          batch_data << Clieop::Payment::Record.new(:payment_name, :name => tr[:account_owner]).to_clieop unless transaction_is_payment?

        end

        # generate batch footer record including some checks
        batch_data << Clieop::Payment::Record.new(:batch_footer, :transaction_count => @transactions.length,
                          :total_amount => total_amount, :account_checksum => account_checksum(total_account)).to_clieop

      end

      alias_method :to_s, :to_clieop

      # creates a batch for payments from a given account
      def self.payment_batch(batch_info = {})
        batch_info[:transaction_group] ||= 0
        Clieop::Payment::Batch.new(batch_info)
      end

      # creates a batch for invoices to a given account
      def self.invoice_batch(batch_info = {})
        batch_info[:transaction_group] ||= 10
        Clieop::Payment::Batch.new(batch_info)
      end

      # the checksum on the total of accounts is in fact the last 10 chars of total amount
      def account_checksum(total)
        total.to_s.split('').last(10).join('') # ruby 1.8.6
        # total.to_s.chars.last(10).join('')     # ruby 1.8.7
      end

    private

      def transaction_is_payment?
        @batch_info[:transaction_group] == 10
      end
    end
  end
end
