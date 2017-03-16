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
  HTTP::Protection::Deflect.new,
  HTTP::Protection::IpSpoofing.new,
  HTTP::Protection::PathTraversal.new,
  HTTP::Protection::RemoteReferrer.new,
  HTTP::Protection::XSSHeader.new
])

server.listen
```

### RemoteReferrer middleware

You can define the HTTP methods that are allowed. It does not accept unsafe HTTP requests if the Referer header is set to a different host.

**Example:**

```crystal
HTTP::Protection::RemoteReferrer.new(methods: %w[GET])
```

### Deflect middleware

You can define a several options for this middleware. It protecting against Denial-of-service attacks.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
interval | Duration in seconds until the request counter is reset. | 5 | Int32
duration | Duration in seconds that a remote address will be blocked. | 900 | Int32
threshold | Number of requests allowed. | 100 | Int32
blacklist | Array of remote addresses immediately considered malicious. | [] | Array(String)
whitelist | Array of remote addresses which bypass Deflect. | [] | Array(String)

**Example:**

```crystal
HTTP::Protection::Deflect.new(
  interval: 5,
  duration: 5,
  threshold: 10,
  blacklist: ["111.111.111.111"],
  whitelist: ["222.222.222.222"]
)
```

## Contributing

1. Fork it ( https://github.com/rogeriozambon/http-protection/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [rogeriozambon](https://github.com/rogeriozambon) Rogério Zambon - creator, maintainer
