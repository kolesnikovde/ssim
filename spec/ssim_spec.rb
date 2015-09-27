require 'spec_helper'

describe SSIM do
  URL = File.expand_path('../sample.ssim', __FILE__)

  describe '.schedule' do
    it 'provides info about dates' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7))

      expect(schedule.created_at).to eq(Date.new(2014, 11, 4))
      expect(schedule.from_date).to  eq(Date.new(2014, 11, 4))
      expect(schedule.to_date).to    eq(nil)
    end

    it 'provides info about flights' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7))
      table = schedule.table

      expect(table['0423'].map(&:to_hash)).to eq([{
        'aircraft_type' => 'A40',
        'arrival_point' => 'BQJ',
        'arrival_time' => DateTime.parse('10:30 +09:00'),
        'itinerary_variation_id' => '01',
        'days_of_operations' => [ 5 ],
        'departure_point' => 'YKS',
        'departure_time' => DateTime.parse('08:30 +09:00'),
        'flight_number' => '0423',
        'from_date' => Date.new(2014, 11, 7),
        'to_date' => Date.new(2014, 12, 26)
      }])

      expect(table['0424'].map(&:to_hash)).to eq([{
        'aircraft_type' => 'A40',
        'arrival_point' => 'YKS',
        'arrival_time' => DateTime.parse('13:20 +09:00'),
        'itinerary_variation_id' => '01',
        'days_of_operations' => [ 5 ],
        'departure_point' => 'BQJ',
        'departure_time' => DateTime.parse('11:20 +09:00'),
        'flight_number' => '0424',
        'from_date' => Date.new(2014, 11, 7),
        'to_date' => Date.new(2014, 12, 26)
      }])
    end

    it 'groups flights with same itinerary variation id' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7))
      table = schedule.table

      expect(table['0755'].map(&:to_hash)).to eq([{
        'flight_number' => '0755',
        'itinerary_variation_id' => '01',
        'from_date' => Date.new(2014, 11, 13),
        'to_date' => Date.new(2014, 11, 13),
        'days_of_operations' => [ 4 ],
        'departure_point' => 'KRR',
        'departure_time' => DateTime.parse('23:25:00 +0900'),
        'arrival_point' => 'OVB',
        'arrival_time' => DateTime.parse('03:20:00 +0900'),
        'aircraft_type' => '73W'
      }, {
        'flight_number' => '0755',
        'itinerary_variation_id' => '01',
        'from_date' => Date.new(2014, 11, 14),
        'to_date' => Date.new(2014, 11, 14),
        'days_of_operations' => [ 5 ],
        'departure_point' => 'OVB',
        'departure_time' => DateTime.parse('04:50:00 +0900'),
        'arrival_point' => 'GDX',
        'arrival_time' => DateTime.parse('10:00:00 +0900'),
        'aircraft_type' => '73W'
      }])
    end
  end
end
