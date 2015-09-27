module SSIM
  module Records
    class Header < Base
      attr_accessor :serial_number

      REGEXP = /^1AIRLINE\ STANDARD\ SCHEDULE\ DATA\ SET[\ ]+000001$/

      def parse(record)
        raise InvalidRecordError if record !~ REGEXP

        @serial_number = record[194..199]
      end
    end
  end
end
