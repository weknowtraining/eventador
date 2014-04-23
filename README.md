# Eventador

Simple callbacks/lightweight events on procs.

## Installation

Add this line to your application's Gemfile:

    gem 'eventador'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eventador

## Usage

    def thing(&block)
      if ok?
        block.callback(:ok, data)
      else
        block.callback(:error)
      end
    end

    thing do |on|
      on.ok do |payload|
        ...
      end

      on.error do
        ...
      end
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/eventador/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
