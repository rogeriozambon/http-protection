##
# Middleware for protecting against unsafe HTTP requests if the Referer header is set to a different host.
# http://en.wikipedia.org/wiki/Cross-site_request_forgery
#
# === Options:
#
#   :methods  Defines which HTTP method should be used. Defaults to GET, HEAD, OPTIONS, TRACE
#
# === Examples:
#
#  HTTP::Protection::RemoteReferer.new(methods: ["GET"])
#
module HTTP::Protection
  class RemoteReferer
    include Base
    include HTTP::Handler

    def initialize(@methods : Array(String) = ["GET", "HEAD", "OPTIONS", "TRACE"])
    end

    def call(context : HTTP::Server::Context)
      headers = context.request.headers

      return call_next(context) unless headers.has_key?("Referer")

      referer = headers["Referer"]

      return forbidden(context) unless referer.empty? || safe?(context)
      return forbidden(context) unless URI.parse(referer).host == context.request.host

      call_next(context)
    end
  end
end
