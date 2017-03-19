# http-protection

[![Build Status](https://travis-ci.org/rogeriozambon/http-protection.svg?branch=master)](https://travis-ci.org/rogeriozambon/http-protection)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/rogeriozambon/http-protection/master/LICENSE)

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
  HTTP::Protection::Origin.new,
  HTTP::Protection::PathTraversal.new,
  HTTP::Protection::RemoteReferrer.new,
  HTTP::Protection::StrictTransport.new,
  HTTP::Protection::XSSHeader.new
])

server.listen
```

### Deflect middleware

It protects against Denial-of-service attacks. You can define a several options for this middleware.

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

It protects against clickjacking, setting header to tell the browser avoid embedding the page in a frame. You can define one option for this middleware.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
option | Defines who should be allowed to embed the page in a frame. Use "DENY" or "SAMEORIGIN". | SAMEORIGIN | String

**Example:**

```crystal
HTTP::Protection::FrameOptions.new(option: "SAMEORIGIN")
```

### IpSpoofing middleware

It detects IP spoofing attacks.

**Example:**

```crystal
HTTP::Protection::IpSpoofing.new
```

### Origin middleware

It protects against unsafe HTTP requests when value of Origin HTTP request header doesn't match default or whitelisted URIs. You can define the whitelist of URIs.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
whitelist | Array of allowed URIs | [] | Array(String)

**Example:**

```crystal
HTTP::Protection::Origin.new(whitelist: ["http://friend.com"])
```

### PathTraversal middleware

It protects against unauthorized access to file system attacks, unescapes '/' and '.' from PATH_INFO.

**Example:**

```crystal
HTTP::Protection::PathTraversal.new
```

### RemoteReferrer middleware

It doesn't accept unsafe HTTP requests if the Referer header is set to a different host. You can define the HTTP methods that are allowed.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
methods | Defines which HTTP method should be used. | GET, HEAD, OPTIONS, TRACE | Array(String)

**Example:**

```crystal
HTTP::Protection::RemoteReferrer.new(methods: ["GET"])
```

### StrictTransport middleware

It protects against protocol downgrade attacks and cookie hijacking. You can define some options for this middleware.

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

### XSSHeader middleware

It sets X-XSS-Protection header to tell the browser to block attacks. XSS vulnerabilities enable an attacker to control the relationship between a user and a web site or web application that they trust.

You can define some options for this middleware.

Option | Description | Default value | Type
------ | ----------- | ------------- | ----
xss_mode | How the browser should prevent the attack. | block | String
nosniff | Blocks a request if the requested type is "style" or "script". | true | Bool

**Example:**

```crystal
HTTP::Protection::XSSHeader.new(
  xss_mode: "block"
  nosniff: true
)
```

## TODO

- [x] Change README to include a description for each middleware.
- [x] Add documentation for all middlewares.

## Contributing

1. Fork it ( https://github.com/rogeriozambon/http-protection/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [rogeriozambon](https://github.com/rogeriozambon) Rogério Zambon - creator, maintainer
