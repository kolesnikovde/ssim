module SSIM
  module Records
    class Base
      attr_accessor :type, :serial_number

      def self.parse(row)
        raise InvalidRecordError unless (type = row[0])
        return if (type = type.to_i) <= 0

        RECORD_TYPES[type].new.tap { |r| r.parse(row) }
      end

      def parse(record)
        @type = record[0].to_i
        @serial_number = record[194..199]
      end

      def to_hash
        instance_values
      end

      private

      def parse_date(date, time = nil)
        date += ' ' + format_time(time) if time
        date = Date.parse(date) rescue nil
        date
      end

      def parse_time(time)
        Time.parse(format_time(time)) rescue nil
      end

      def format_time(time)
        time[0..1] + ':' + time[2..-1]
      end
    end
  end
end
