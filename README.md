# http-protection

[![Build Status](https://travis-ci.org/rogeriozambon/http-protection.svg?branch=master)](https://travis-ci.org/rogeriozambon/http-protection)
This library protects against typical web attacks. It was inspired in rack-protection Ruby gem.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  http-protection:
    github: rogeriozambon/http-protection
```

## Usage

```crystal
require "http/server"
require "http-protection"

server = HTTP::Server.new("0.0.0.0", 8080, [
  HTTP::Protection::IpSpoofing.new,
  HTTP::Protection::RemoteReferrer.new
])

server.listen
```

## Contributing

1. Fork it ( https://github.com/rogeriozambon/http-protection/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [rogeriozambon](https://github.com/rogeriozambon) Rogério Zambon - creator, maintainer
