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
#  HTTP::Protection::RemoteReferrer.new(methods: ["GET"])
#
module HTTP::Protection
  class RemoteReferrer < Base
    include HTTP::Handler

    def initialize(@methods : Array(String) = ["GET", "HEAD", "OPTIONS", "TRACE"])
    end

    def call(context)
      headers = context.request.headers

      return call_next(context) unless headers.has_key?("HTTP_REFERER")

      referrer = headers["HTTP_REFERER"]

      return false unless referrer.empty? || safe?(context)
      return false unless URI.parse(referrer).host == context.request.host

      call_next(context)
    end
  end
end
