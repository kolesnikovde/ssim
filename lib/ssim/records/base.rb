module SSIM
  module Records
    class Base
      def parse(row)
        raise NotImplementedError
      end

      def to_hash
        Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
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
