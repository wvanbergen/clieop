module Clieop

  class Record

    TYPE_DEFINITIONS = {
        :file_header => [
            [:record_code, :numeric, 4, 1],
            [:record_variant, :alpha, 1, 'A'],
            [:date, :numeric, 6],
            [:filename, :alpha, 8, 'CLIEOP03'],
            [:sender_identification, :alpha, 5],
            [:file_identification, :alpha, 4],
            [:duplicate_code, :numeric, 1, 1]
          ],
        :file_footer => [
            [:record_code, :numeric, 4, 9999],
            [:record_variant, :alpha, 1, 'A'],
          ],
        :batch_header => [
            [:record_code, :numeric, 4, 10],
            [:record_variant, :alpha, 1, 'B'],
            [:transaction_group, :numeric, 2],
            [:acount_nr, :numeric, 10],
            [:serial_nr, :numeric, 4],
            [:currency, :alpha, 3, 'EUR']
          ],
        :batch_footer => [
            [:record_code, :numeric, 4, 9990],
            [:record_variant, :alpha, 1, 'A'],
            [:total_amount, :numeric, 18],
            [:account_checksum, :numeric, 10],
            [:transaction_count, :numeric, 7],
          ],
        :batch_description => [
            [:record_code, :numeric, 4, 20],
            [:record_variant, :alpha, 1, 'A'],
            [:description, :alpha, 32]
          ],
        :batch_owner => [
            [:record_code, :numeric, 4, 30],
            [:record_variant, :alpha, 1, 'B'],
            [:naw_code, :numeric, 1, 1],
            [:process_date, :numeric, 6, 0],
            [:owner, :alpha, 35],
            [:test, :alpha, 1, 'P']
          ],
        :transaction_info => [
            [:record_code, :numeric, 4, 100],
            [:record_variant, :alpha, 1, 'A'],
            [:transaction_type, :numeric, 4, 1002],
            [:amount, :numeric, 12],
            [:from_account, :numeric, 10],
            [:to_account, :numeric, 10],
          ],
        :invoice_name => [
            [:record_code, :numeric, 4, 110],
            [:record_variant, :alpha, 1, 'B'],
            [:name, :alpha, 35],
          ],
        :transaction_reference => [
            [:record_code, :numeric, 4, 150],
            [:record_variant, :alpha, 1, 'A'],
            [:reference_number, :alpha, 16],
          ],
        :transaction_description => [
            [:record_code, :numeric, 4, 160],
            [:record_variant, :alpha, 1, 'A'],
            [:description, :alpha, 32],
          ],
        :payment_name =>[
            [:record_code, :numeric, 4, 170],
            [:record_variant, :alpha, 1, 'B'],
            [:name, :alpha, 35],
          ],
    }

    attr_accessor :definition, :data

    def initialize record_type, record_data = {}

      # load record definition
      raise "Unknown record type" unless Clieop::Record::TYPE_DEFINITIONS[record_type.to_sym]
      @definition = Clieop::Record::TYPE_DEFINITIONS[record_type.to_sym]

      # set default values according to definition
      @data = @definition.inject({}) { |memo, field| memo[field[0]] = field[3] if field[3] ; memo }

      # set values for all the provided data
      record_data.each { |field, value| @data[field] = value }
    end

    def to_clieop
      line = ""
      # format each field
      @definition.each do |field, type, length, content|
        fmt = '%'
        fmt << (type == :numeric ? '0' : '-')
        fmt << (length.to_s)
        fmt << (type == :numeric ? 'd' : 's')
        raw_data = (type == :numeric) ? @data[field].to_i : @data[field]
        value = sprintf(fmt, raw_data)
        line << (type == :numeric ? value[0 - length, length] : value[0, length])
      end
      # fill each line with spaces up to 50 characters and close with a CR/LF
      line.ljust(50) + "\r\n"
    end

    alias_method :to_s, :to_clieop
  end
end
