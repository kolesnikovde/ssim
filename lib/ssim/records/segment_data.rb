module SSIM
  module Records
    class SegmentData < Base
      attr_reader :flight_number,
                  :board_point_indicator,
                  :off_point_indicator,
                  :board_point,
                  :off_point

      def parse(record)
        @flight_number         = record[5..8]
        @board_point_indicator = record[28]
        @off_point_indicator   = record[29]
        @board_point           = record[33..35]
        @off_point             = record[36..38]
      end
    end
  end
end
