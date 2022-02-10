# parse-cron-ext
[![Gem Version](https://badge.fury.io/rb/parse-cron-ext.svg)](https://badge.fury.io/rb/parse-cron-ext)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

parse-cron-ext is a extension (monkey-patch) for parse-cron 0.1.4, which is the latest version.  
siebertm/parse-cron: https://github.com/siebertm/parse-cron

Warning:   
All specs written in parse-cron passed, but Use at your own risk.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'parse-cron-ext'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install parse-cron-ext

## Usage
 These notations are inspired by [AWS Cron Expressions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html).
 

### End of the month by using L notation
 ```ruby
   cron_parser = CronParser.new('0 9 L * *')

   time = Time.local(2022, 1, 16, 12, 0)
   cron_parser.next(time)
   # => 2022-01-31 09:00
   
   time = Time.local(2022, 2, 3, 12, 0)
   cron_parser.next(time)
   # => 2022-02-28 09:00
   
   
   # end of March
   cron_parser = CronParser.new('0 9 L 3 *')

   time = Time.local(2022, 2, 3, 12, 0)
   cron_parser.next(time)
   # => 2022-03-31 09:00
 ```

### Second Sunday, Third Friday...
 ```ruby
   # second sunday
   cron_parser = CronParser.new('0 9 * * SUN#2')

   time = Time.local(2022, 1, 3, 12, 0)
   cron_parser.next(time)
   # => 2022-01-09 09:00
   

   # second sunday in march
   cron_parser = CronParser.new('0 9 * 3 SUN#2')

   time = Time.local(2022, 1, 3, 12, 0)
   cron_parser.next(time)
   # => 2022-03-31 09:00
 ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a5-stable/parse-cron-ext. 
This project is intended to be a safe, welcoming space for collaboration!

Any Pull Requests or Issues to improve it will be gladly welcome.
I will check them and react as soon as possible.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
