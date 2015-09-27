require 'open-uri'

module SSIM
  PARSERS = [
    Records::Base,
    Records::Header,
    Records::Carrier,
    Records::FlightLeg,
    Records::SegmentData,
    Records::Trailer,
  ]

  def self.read(url)
    parse(open(url) { |f| f.read })
  end

  def self.parse(data)
    data.split("\n").map { |row| Record.parse(row) }.compact
  end

  class Schedule
    attr_accessor :table, :created_at, :from_date, :to_date

    def initialize(date)
      @date = date
      @table = {}
    end

    def self.build(date, records)
      records.each_with_object(new(date)) do |record, schedule|
        case record
        when CarrierRecord
          schedule.set_carrier(record)
        when FlightLegRecord
          schedule.add_flight_leg(record)
        end
      end
    end

    def set_carrier(record)
      @from_date = record.from_date
      @to_date = record.to_date
      @created_at = record.created_at
    end

    def add_flight_leg(flight)
      if matches_date?(flight) or parent_leg_present?(flight)
        flights = @table[flight.flight_number] ||= []
        flights << flight
      end
    end

    def to_hash
      instance_values
    end

    protected

    def matches_date?(flight)
      (flight.from_date..flight.to_date).include?(@date) and
        flight.days_of_operations.include?(@date.wday)
    end

    def parent_leg_present?(flight)
      if flights = @table[flight.flight_number]
        flights.any? do |f|
          f.itinerary_variation_id == flight.itinerary_variation_id
        end
      end
    end
  end

  def self.filter(flights, options)
    date = options[:date] ? Date.parse(options[:date]) : Date.today
    departure = options[:departure].presence
    arrival = options[:arrival].presence

    schedule = Schedule.build(date, flights).table
    return schedule unless departure or arrival

    schedule.select do |f, legs|
      legs.any?{ |l| l.points_matches?(departure, arrival) }
    end
  end
end
