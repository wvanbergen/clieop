require 'time'
require 'bigdecimal'

module Clieop  
  module ProcessInfo
    
    # Reads VERWINFO 4.1 process info
    # Docs: http://www.equens.com/Images/VERWINFO%20NL%204.1_11-2009.pdf
    class Record
      
      attr_accessor :type, :raw_line, :definition, :data
    
      LINE_SEPARATOR = "\r\n"

      TYPE_DEFINITIONS = {
          :file_header => [
              [:record_code, :numeric, 3, 10],
              [:filename, :alpha, 8, 'VERWINFO'],
              [:filler, :alpha, 1, 'A'],
              [:file_version, :alpha, 3, '4.1'],
              [:date, :date, 6],            
              [:run_number, :numeric, 4],
              [:account_nr, :numeric, 10],
              [:serial_nr, :numeric, 4],    
              [:file_nr, :numeric, 2]
            ],
          :file_footer => [
              [:record_code, :numeric, 3, 990],
              [:batches_count, :numeric, 6],
              [:next_file_nr, :numeric, 2]           
            ],
          :batch_header => [
              [:record_code, :numeric, 3, 50],
              [:account_nr, :numeric, 10],            
              [:filler, :alpha, 3],
              [:total_amount, :amount, 18],  
              [:transaction_count, :numeric, 7],
              [:test_code, :alpha, 1], # P(roduction), T(est)
              [:batch_type, :alpha, 1],
              [:period_type, :alpha, 1],
              [:period_length, :numeric, 2],
              [:period_nr, :numeric, 3]
            ],
          :batch_info => [
              [:record_code, :numeric, 3, 51],
              [:currency, :alpha, 3],
              [:batch_identifier, :alpha, 16]            
            ],
          :batch_footer => [
              [:record_code, :numeric, 3, 950],
              [:total_rejected, :numeric, 7],
              [:total_reversed, :numeric, 7],
              [:transaction_count, :numeric, 7],
              [:total_amount, :amount, 18] 
            ],
          :transaction_info => [
              [:record_code, :numeric, 3, 100],
              [:amount, :amount, 13],
              [:from_account, :numeric, 10],
              [:to_account, :numeric, 10],
              [:entry_account, :numeric, 10],
            
              # from_account_verification_nr - Controlecijfer rekeningnummer betaler
              # 0 – 9   als Rekeningnummer betaler een rekeningnummer met maximaal 7 cijfers bevat
              # spatie  als Rekeningnummer betaler een gewoon rekeningnummer bevat            
              [:from_account_verification_nr, :numeric, 1],
            
              # transaction_reference_ok - Betalingskenmerkgoed
              # J       controlecijfer juist
              # N       controlecijfer onjuist
              # spatie  geen controlecijfer aanwezig            
              [:transaction_reference_ok, :alpha, 1]
            ],
          :euro_record => [
              [:record_code, :numeric, 3, 101],
              [:currency, :alpha, 3],
              [:amount_nlg, :amount, 13],
              [:amount_eur, :amount, 13]
            ],
          :reverse_info => [
              [:record_code, :numeric, 3, 105],
              [:transaction_reference, :alpha, 16],
              [:inquiry_identifier, :alpha, 19],
            
              # reason - Redenstorno Signaalcode Signaaltekst 
              # 
              # 01          0010        Administratieve reden 
              # 02          0011        Rekeningnummer vervallen 
              # 03          0001        Rekeningnummer onbekend 
              # 05          0012        Geen incassomachtiging verstrekt 
              # 06          0013        Niet akkoord met afschrijving  
              # 07          0014        Dubbel betaald 
              # 08          0005        Naam/nummer stemmen niet overeen 
              # 09          0007        Rekeningnummer geblokkeerd 
              # 10          0008        Selektieve incasso blokkade 
              # 11          0009        Rekeningnummer WKA            
              [:reason, :numeric, 2],
            
              [:original_to_account, :numeric, 10]
            ],
          :transaction_description => [
              [:record_code, :numeric, 3, 110],
              [:description, :alpha, 32]
            ],
          :bank_info => [
              [:record_code, :numeric, 3, 115],
              [:description, :alpha, 30]
            ],   
          :settle_info => [
              [:record_code, :numeric, 3, 500],
            
              # status - Poststatus
              # 00  niet van toepassing (Batchsoorten B en C) 
              # 01  geweigerde post
              # 02  teruggebogen post               
              [:status, :numeric, 2],
            
              [:original_settle_date, :date, 6],
              [:filler, :alpha, 14],
              [:run_nr, :numeric, 4],
              [:settle_date, :date, 6],
            
              # transaction_type - Transactiesoort
              # 0000  crediteuren betalingen 
              # 0001  door bank geconverteerde opdrachten 
              # 0002  periodieke overboekingen
              # 0003  salarissen
              # 0006  iDEAL internet betalingen 
              # 0009  Digitale Nota betalingen 
              # 0092  EBALink betaling
              # 0220  doorlopende machtiging algemeen 
              # 0221  eenmalige machtiging 
              # 0222  doorlopende machtiging bedrijven 
              # 0223  doorlopende machtiging kansspelen 
              # 0227  doorlopende machtiging bedrijven zonder terugboekingsrecht debiteur 
              # 0228  doorlopende telefonische machtiging 
              # 0229  eenmalige telefonische machtiging 
              # 0284  doorlopende telefonische machtiging kansspelen 
              # 0285  overheidsvordering 
              # 0330  terugboeking op doorlopende machtiging algemeen 
              # 0331  terugboeking op eenmalige machtiging 
              # 0332  terugboeking op doorlopende machtiging bedrijven
              # 0333  terugboeking op doorlopende machtiging kansspelen
              # 0337  terugboeking op doorlopende machtiging bedrijven zonder terugboekingsrecht debiteur 
              # 0338  terugboeking op doorlopende telefonische machtiging
              # 0339  terugboeking op eenmalige telefonische machtiging 
              # 0394  terugboeking op doorlopende telefonische machtiging kansspelen 
              # 0395  terugboeking op Overheidsvordering
              # 1010  betaalautomaat transactie
              # 1144  acceptgiro zonder bedrag in coderegel 
              # 1145  acceptgiro met bedrag in coderegel             
              [:transaction_type, :numeric, 4]
            ],
          :changed_account_info => [
              [:record_code, :numeric, 3, 503],
              [:account_nr, :numeric, 10],
              [:original_account_nr, :numeric, 10]
            ],
          :name_info => [
              [:record_code, :numeric, 3, 505],
              [:name, :alpha, 35]
            ],
          :street_info => [
              [:record_code, :numeric, 3, 510],
              [:street, :alpha, 35]
            ],
          :city_info => [
              [:record_code, :numeric, 3, 515],
              [:city, :alpha, 35]
            ],
          
          # See 'Bijlage 1'
          :reject_info => [
              [:record_code, :numeric, 3, 600],
              [:code, :numeric, 4],
              [:description, :alpha, 32]
            ]
      }
      
      TYPE_FOR_RECORD_CODE = TYPE_DEFINITIONS.inject({}){|m, (k,v)| m[v.first.last] = k; m }
      
      def initialize record_line
        self.raw_line = record_line
        self.type = TYPE_FOR_RECORD_CODE[raw_line[0,3].to_i]
        self.data = {}
        self.definition = TYPE_DEFINITIONS[type]
        
        skip = 0
        definition.each do |attribute_definition|
          # Get the right substring
          attribute_line = raw_line[skip, attribute_definition[2]]
          # Parse the attribute
          data[attribute_definition[0]] =  attribute_line.to_s.present? ? self.class.send("parse_#{attribute_definition[1]}_value", attribute_line) : nil
          # Update the skip
          skip += attribute_definition[2]
        end        
      end
      
      private
      
      def self.parse_alpha_value attribute_line
        attribute_line.strip 
      end
      
      def self.parse_numeric_value attribute_line
        attribute_line.to_i
      end
      
      def self.parse_amount_value attribute_line
        (BigDecimal(attribute_line) / 100).round(2)
      end      
      
      # Format: jjmmdd
      def self.parse_date_value attribute_line
        Time.parse(attribute_line).to_date
      end
      

    end    
  end  
end
