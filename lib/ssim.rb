require 'open-uri'
require 'ssim/errors'
require 'ssim/schedule'
require 'ssim/records/base'
require 'ssim/records/header'
require 'ssim/records/carrier'
require 'ssim/records/flight_leg'
require 'ssim/records/segment_data'
require 'ssim/records/trailer'
require 'ssim/version'

module SSIM
  RECORDS = [
    Records::Base,
    Records::Header,
    Records::Carrier,
    Records::FlightLeg,
    Records::SegmentData,
    Records::Trailer,
  ]

  module_function

  def read(url)
    parse(open(url, &:read))
  end

  def parse(data)
    data.split("\n").map do |row|
      raise InvalidRecordError unless (type = row[0])
      next if (type = type.to_i) < 1
      RECORDS[type].new.tap { |r| r.parse(row) }
    end.compact
  end

  def schedule(options = {})
    records = case
              when options[:records] then options[:records]
              when options[:data]    then parse(options[:data])
              when options[:url]     then read(options[:url])
              end

    Schedule.new(options).tap { |s| s.fill(records) }
  end
end
