# SSIM

[SSIM](http://www.iata.org/publications/Pages/ssim.aspx) parser for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ssim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ssim

## Usage

```ruby
schedule = SSIM.schedule(
  url: 'path/to/file.ssim',
  date: Date.today,
  # optional IATA codes for departure and arrival points
  departure_point: 'YKS'
)

schedule.table
schedule.created_at
schedule.from_date
schedule.to_date
```

## License

MIT
