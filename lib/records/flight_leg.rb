module SSIM
  module Records
    class FlightLeg < Base
      attr_accessor :flight_number,
                    :itinerary_variation_id,
                    :from_date,
                    :to_date,
                    :days_of_operations,
                    :departure_point,
                    :departure_time,
                    :arrival_point,
                    :arrival_time,
                    :aircraft_type

      def parse(record)
        @flight_number          = record[5..8]
        @itinerary_variation_id = record[9..10]
        @from_date              = parse_date(record[14..20])
        @to_date                = parse_date(record[21..27])
        @days_of_operations     = parse_doo(record[28..34])
        @departure_point        = record[36..38]
        @departure_time         = parse_time(record[43..51])
        @arrival_point          = record[54..56]
        @arrival_time           = parse_time(record[61..69])
        @aircraft_type          = record[72..74]
      end

      def points_matches?(departure = nil, arrival = nil)
        (departure ? (departure_point == departure) : true) \
          && (arrival ? (arrival_point == arrival) : true)
      end

      private

      def parse_doo(wdays)
        wdays.split('').reject(&:blank?).map(&:to_i)
      end
    end
  end
end
