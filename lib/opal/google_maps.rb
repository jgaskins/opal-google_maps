require 'opal'
require "opal/google_maps/version"

module Opal
  module GoogleMaps
    def google_maps key, libraries: [], async: false
      %{<script src="https://maps.googleapis.com/maps/api/js?key=#{key}&libraries=#{libraries.join(',')}"#{' async defer' if async}></script>}
    end
  end
end

Opal.append_path File.expand_path('../../../opal', __FILE__)
