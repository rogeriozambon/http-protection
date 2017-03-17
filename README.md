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
  HTTP::Protection::FrameOptions.new,
  HTTP::Protection::IpSpoofing.new,
  HTTP::Protection::PathTraversal.new,
  HTTP::Protection::RemoteReferrer.new,
  HTTP::Protection::StrictTransport.new,
  HTTP::Protection::XSSHeader.new
])

server.listen
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

### FrameOptions middleware

You can define one option for this middleware. It protecting against clickjacking, setting header to tell the browser avoid embedding the page in a frame.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
option | Defines who should be allowed to embed the page in a frame. Use "DENY" or "SAMEORIGIN". | SAMEORIGIN | String

**Example:**

```crystal
HTTP::Protection::FrameOptions.new(option: "SAMEORIGIN")
```

### RemoteReferrer middleware

You can define the HTTP methods that are allowed. It does not accept unsafe HTTP requests if the Referer header is set to a different host.

**Example:**

```crystal
HTTP::Protection::RemoteReferrer.new(methods: %w[GET])
```

### StrictTransport middleware

You can define some options for this middleware. It protects against protocol downgrade attacks and cookie hijacking.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
max_age | How long future requests to the domain should go over HTTPS (in seconds). | 31536000 | Int32
include_subdomains | If all present and future subdomains will be HTTPS. | false | Bool
preload | Allow this domain to be included in browsers HSTS preload list. | false | Bool

**Example:**

```crystal
HTTP::Protection::StrictTransport.new(
  max_age: 31536000,
  include_subdomains: false,
  preload: false
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
