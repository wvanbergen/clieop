module Clieop
  module ProcessInfo
    
    class Transaction

      attr_accessor :info, :descriptions, :record

      def initialize(record)
        self.record = record
        self.info = record.data.except(:record_code)
      end
      
      def add_record record
        unless record.type == :transaction_description
          info[record.type] = record.data.except(:record_code, :filler)
        else
          info[:transaction_descriptions] ||= []
          info[:transaction_descriptions] << record.data[:description]         
        end
      end

    end
  end
end