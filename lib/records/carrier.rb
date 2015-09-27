module SSIM
  module Records
    class Carrier < Base
      attr_accessor :from_date,
                    :to_date,
                    :created_at

      def parse(record)
        @from_date  = parse_date(record[14..20])
        @to_date    = parse_date(record[21..27])
        @created_at = parse_date(record[28..34], record[190..193])
      end
    end
  end
end
