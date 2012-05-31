module Clieop
  module ProcessInfo

    # Reads VERWINFO 4.1 process info, see record.rb for details
    class File
      
      attr_accessor :records, :batches, :info

      def initialize(verwinfo_string, whiny_mode = false)
        self.records = verwinfo_string.split(Clieop::ProcessInfo::Record::LINE_SEPARATOR).map do |record_line| 
          unless record_line.size < 3 # No record code available
            begin
              Clieop::ProcessInfo::Record.new(record_line)
            rescue Exception => e
              whiny_mode ? raise(e) : nil
            end
          end
        end.compact
        
        raise 'No valid records found in VERWINFO data' unless @records.any?
        
        self.batches = []
        self.info = records.first.data.merge(records.last.data).except(:record_code, :filler) # Get file header and footer
        
        current_batch = nil; current_transaction = nil
        records.each do |record|
          case record.type
          when :batch_header 
            current_batch = Clieop::ProcessInfo::Batch.new
            current_transaction = nil
            batches << current_batch
          when :transaction_info, :changed_account_info
            current_transaction = Clieop::ProcessInfo::Transaction.new(record)
          end
          
          current_batch.add_record(record, current_transaction) if current_batch          
        end
      end
   
      def self.from_file(verwinfo_file, whiny_mode = false)
        verwinfo_file = File.open(verwinfo_file) if verwinfo_file.is_a?(String)
        self.from_string(verwinfo_file.read, whiny_mode)
      end
    
      def self.from_string(verwinfo_string, whiny_mode = false)
        self.new(verwinfo_string, whiny_mode)
      end
      
    end
  end
end