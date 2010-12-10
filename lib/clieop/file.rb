module Clieop

  class File

    attr_accessor :batches
    attr_reader   :file_info

    def initialize(file_info = {})
      file_info[:date] = Date.today unless file_info[:date]
      file_info[:date] = file_info[:date].strftime('%d%m%y') if file_info[:date].respond_to?(:strftime)
      @file_info = file_info
      @batches = []
    end

    # renders this file as a CLIEOP03 formatted string
    def to_clieop
      clieop_data = Clieop::Record.new(:file_header, @file_info).to_clieop
      @batches.each { |batch| clieop_data << batch.to_clieop }
      clieop_data << Clieop::Record.new(:file_footer).to_clieop
    end

    # Alias for to_clieop
    alias :to_s :to_clieop

    def payment_batch(options)
      @batches << Clieop::Batch.payment_batch(options)
      yield(@batches.last) if block_given?
      return @batches.last
    end

    def invoice_batch(options)
      @batches << Clieop::Batch.invoice_batch(options)
      yield(@batches.last) if block_given?
      return @batches.last
    end

    def save(filename)
      ::File.open(filename, 'w') do |f|
        f.write(self.to_clieop)
      end
    end
  end
end
