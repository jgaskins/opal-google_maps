# Opal::GoogleMaps

Ruby bindings for client-side Google Maps integration via Opal and helpers for server-side loading.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal-google_maps'
```

And then execute:

    $ bundle

## Usage

Since this gem is a Ruby interface for Google Maps, it requires that the Google Maps JS library be loaded (from Google) first. This is as simple as putting the following line in your server-side application's view template:

```erb
<%= Opal::GoogleMaps.google_maps(YOUR_API_KEY) %>
```

This will add a `<script>` tag to the rendered HTML with your API key.

### Client-side

If you're using this gem with Clearwater, you'll want to render it into a `Clearwater::BlackBoxNode` rather than a simple `Clearwater::Component`. The `BlackBoxNode` gives you callbacks for `mount`, `update`, and `unmount`, but the simpler components do not. For example:

```ruby
require 'clearwater/black_box_node' # It is not loaded with Clearwater by default
require 'google/maps' # No need for the `opal` namespace

class MyMap
  include Clearwater::BlackBoxNode
  include Google::Maps # So we don't have to namespace every constant

  attr_reader :map

  def node
    # Important to set the dimensions of the map container
    Clearwater::Component.div(style: { width: '600px', height: '600px' })
  end

  def mount(element)
    # Need to delay this one animation frame so the div we specified above is
    # actually in the rendered DOM. Google Maps needs to get the dimensions of
    # the map from a fully rendered DOM node.
    Bowser.window.animation_frame do
      # Similar to the `google.maps.Map` namespace
      @map = Map.new(
        element, # passed into this method
        center: LatLng.new(-34.397, 150.644), # Sydney, NSW, Australia
        zoom: 8,
      )
    end
  end

  # Each time you render a BlackBoxNode, you get a new instance, so you need
  # to copy it across instances if you want to operate on it across renders.
  # If you're only rendering it and never doing anything with it, you can omit
  # this method entirely.
  def update(previous, element)
    @map = previous.map
  end
end
```

### Loading other Google Maps JS libraries

Google Maps has several additional libraries to choose from. To load them, add the `libraries` key to your server-side rendering call:

```erb
<%= Opal::GoogleMaps.google_maps(YOUR_API_KEY, libraries: %w[drawing geometry places visualization]) %>
```

### Loading Google Maps asynchronously

You can use the `async` keyword argument to load the Google Maps libraries in a way that will not block rendering.

```erb
<%= Opal::GoogleMaps.google_maps(YOUR_API_KEY, async: true) %>
```

Keep in mind that this can cause problems if your app renders a map immediately on load. If you load Google Maps asynchronously, it isn't guaranteed to be loaded before your app. In such a case, you may get an error saying something to the effect of `google is not an object`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jgaskins/opal-google_maps. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Opal::GoogleMaps project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jgaskins/opal-google_maps/blob/master/CODE_OF_CONDUCT.md).
