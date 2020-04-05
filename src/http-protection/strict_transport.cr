##
# Middleware for protecting against protocol downgrade attacks and cookie hijacking.
# https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
#
# === Options:
#
#   :max_age             How long future requests to the domain should go over HTTPS (in seconds). Defaults to 31536000
#   :include_subdomains  If all present and future subdomains will be HTTPS. Defaults to false
#   :preload             Allow this domain to be included in browsers HSTS preload list. Defaults to false
#
# === Examples:
#
#  HTTP::Protection::StrictTransport.new(max_age: 31536000, include_subdomains: false, preload: false)
#
module HTTP::Protection
  class StrictTransport
    include HTTP::Handler

    def initialize(@max_age : Int32 = 31536000, @include_subdomains : Bool = false, @preload : Bool = false)
    end

    def call(context : HTTP::Server::Context)
      context.response.headers["Strict-Transport-Security"] ||= strict_transport
      call_next(context)
    end

    private def strict_transport
      "max-age=#{@max_age.to_s}#{include_subdomains_option}#{preload_option}"
    end

    private def include_subdomains_option
      "; includeSubDomains" if @include_subdomains
    end

    private def preload_option
      "; preload" if @preload
    end
  end
end
