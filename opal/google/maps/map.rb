require 'bowser/event_target'
require 'google/maps/delegate_native'

module Google
  module Maps
    class Map
      include Bowser::EventTarget
      include DelegateNative

      def initialize element, options={}
        @element = element
        @options = options
        @native = `new google.maps.Map(#{element.to_n}, #{options.to_n})`
      end
    end
  end
end
