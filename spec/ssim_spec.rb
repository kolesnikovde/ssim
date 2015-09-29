require 'spec_helper'

describe SSIM do
  URL = File.expand_path('../sample.ssim', __FILE__)

  describe '.schedule' do
    it 'provides info about schedule' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7))

      expect(schedule.created_at).to eq(Date.new(2014, 11, 4))
      expect(schedule.from_date).to  eq(Date.new(2014, 11, 4))
      expect(schedule.to_date).to    eq(nil)
    end

    it 'filters flights by date' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7))

      expect(schedule.table['0423'].map(&:to_hash)).to eq([{
        'flight_number'          => '0423',
        'itinerary_variation_id' => '01',
        'from_date'              => Date.new(2014, 11, 7),
        'to_date'                => Date.new(2014, 12, 26),
        'days_of_operations'     => [5],
        'departure_point'        => 'YKS',
        'departure_time'         => Time.parse('08:30 +09:00'),
        'arrival_point'          => 'BQJ',
        'arrival_time'           => Time.parse('10:30 +09:00'),
        'aircraft_type'          => 'A40',
      }])

      expect(schedule.table['0424'].map(&:to_hash)).to eq([{
        'flight_number'          => '0424',
        'itinerary_variation_id' => '01',
        'from_date'              => Date.new(2014, 11, 7),
        'to_date'                => Date.new(2014, 12, 26),
        'days_of_operations'     => [5],
        'departure_point'        => 'BQJ',
        'departure_time'         => Time.parse('11:20 +09:00'),
        'arrival_point'          => 'YKS',
        'arrival_time'           => Time.parse('13:20 +09:00'),
        'aircraft_type'          => 'A40',
      }])
    end

    it 'filters flights by arrival point' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7), arrival_point: 'BQJ')
      expect(schedule.table.keys).to eq(['0423'])
    end

    it 'filters flights by departure point' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 7), departure_point: 'YKS')
      expect(schedule.table.keys).to eq(['0423', '0425'])
    end

    it 'groups flights with same itinerary variation id' do
      schedule = SSIM.schedule(url: URL, date: Date.new(2014, 11, 13))

      expect(schedule.table['0755'].map(&:to_hash)).to eq([{
        'flight_number'          => '0755',
        'itinerary_variation_id' => '01',
        'from_date'              => Date.new(2014, 11, 13),
        'to_date'                => Date.new(2014, 11, 13),
        'days_of_operations'     => [ 4 ],
        'departure_point'        => 'KRR',
        'departure_time'         => Time.parse('23:25:00 +0900'),
        'arrival_point'          => 'OVB',
        'arrival_time'           => Time.parse('03:20:00 +0900'),
        'aircraft_type'          => '73W',
      }, {
        'flight_number'          => '0755',
        'itinerary_variation_id' => '01',
        'from_date'              => Date.new(2014, 11, 14),
        'to_date'                => Date.new(2014, 11, 14),
        'days_of_operations'     => [5],
        'departure_point'        => 'OVB',
        'departure_time'         => Time.parse('04:50:00 +0900'),
        'arrival_point'          => 'GDX',
        'arrival_time'           => Time.parse('10:00:00 +0900'),
        'aircraft_type'          => '73W',
      }])
    end
  end
end
