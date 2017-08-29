module Google
  module Maps
    module DelegateNative
      %x{
        var upper = function(char) { return char[char.length - 1].toUpperCase() };
        var titleCase = function(string) {
          return string.replace(/^\w|_\w/, upper)
        };
        var maps = google.maps;
      }

      def method_missing message, *args, &block
        property = `titleCase(#{message})`

        result = if `#@native['get' + #{property}]`
                   puts "#{self.class}#get#{property}(#{args})"
                   `#@native['get' + #{property}].apply(#@native, #{args})`
                 elsif property.end_with?('=') && `#@native['set' + #{property.chop}]`
                   puts "#{self.class}#set#{property.chop}(#{args})"
                   `#@native['set' + #{property.chop}].apply(#@native, #{args})`
                 else
                   super
                 end

        if `#{result} instanceof maps.LatLng`
          LatLng.from_native(result)
        end
      end

      def to_n
        @native
      end
    end
  end
end
