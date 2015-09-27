module SSIM
  class Schedule
    attr_reader :table,
                :from_date,
                :to_date,
                :created_at,
                # filters
                :date,
                :departure_point,
                :arrival_point

    def initialize(options = {})
      @date            = options.fetch(:date)
      @departure_point = options[:departure_point]
      @arrival_point   = options[:arrival_point]
      @table           = {}
    end

    def fill(records)
      records.each do |record|
        case record
        when Records::Carrier
          set_carrier(record)
        when Records::FlightLeg
          add_flight_leg(record)
        end
      end
    end

    def to_hash
      instance_values
    end

    private

    def set_carrier(record)
      @from_date = record.from_date
      @to_date = record.to_date
      @created_at = record.created_at
    end

    def add_flight_leg(flight)
      return unless matches?(flight)

      flights = table[flight.flight_number] ||= []
      flights << flight
    end

    def matches?(flight)
      (matches_points?(flight) && matches_date?(flight)) || parent_leg_present?(flight)
    end

    def matches_points?(flight)
      return false if departure_point && departure_point != flight.departure_point
      return false if arrival_point && arrival_point != flight.arrival_point

      true
    end

    def matches_date?(flight)
      matches_doo?(flight) && (flight.from_date..flight.to_date).include?(date)
    end

    def matches_doo?(flight)
      flight.days_of_operations.include?(date.wday)
    end

    def parent_leg_present?(flight)
      return unless (flights = table[flight.flight_number])

      flights.any? do |f|
        f.itinerary_variation_id == flight.itinerary_variation_id
      end
    end
  end
end
