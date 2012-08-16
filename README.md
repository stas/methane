# Methane

Methane was supposed to be a ruby cross-platform Campfire client.

The idea was to build the GUI using qtruby and qt-webkit.
Where HTML UI elements (with Tempo.js/jQuery) inside a webkit frame
communicate through a websocket with
the the backend (EventMachine + tweetstream + tinder).

## Failure

I failed to get a stable build (qtruby keept crashing for any unknown reason)
so I discontinued any development.

Who knows, I might or not get back to this idea with a smarter approach.
Till then feel free to play with it and hack around.

## Installation

Add this line to your application's Gemfile:

    gem 'methane'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install methane

## Usage

Building qtruby might take some time. Please be patient, after what just run:

    $ bundle exec methane

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
