require 'bowser/event_target'
require 'google/maps/map'
require 'google/maps/delegate_native'

module Google
  module Maps
    class LatLng
      attr_reader :lat, :lng

      def self.from_native native
        new(`#{native}.lat()`, `#{native}.lng()`)
      end

      def initialize lat, lng
        @lat = lat
        @lng = lng
      end

      # An instance of this class can stand in for a google.maps.LatLng instance
      def to_n
        self
      end

      alias latitude lat
      alias longitude lng
    end

    class Marker
      include DelegateNative
      include Bowser::EventTarget

      def initialize options={}
        @native = `new maps.Marker(#{options.to_n})`
      end
    end
  end
end

require 'google/maps/map'
