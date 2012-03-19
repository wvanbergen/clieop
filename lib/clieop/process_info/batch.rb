module Clieop
  module ProcessInfo
    
    class Batch

      attr_accessor :info, :transactions

      def initialize
        self.transactions = []
        self.info = {}
      end
      
      def add_record record, current_transaction = nil
        if [:batch_header, :batch_info, :batch_footer].include?(record.type)
          info.merge!(record.data.except(:record_code, :filler))
        elsif current_transaction
          if record == current_transaction.record
            transactions << current_transaction
          else
            current_transaction.add_record(record)
          end
        end
      end

    end
  end
end
