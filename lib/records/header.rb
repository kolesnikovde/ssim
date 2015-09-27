module SSIM
  module Records
    class Header < Base
      REGEXP = /^1AIRLINE\ STANDARD\ SCHEDULE\ DATA\ SET[\ ]+000001$/

      def parse(record)
        raise InvalidRecordError unless record =~ REGEXP

        super
      end
    end
  end
end
