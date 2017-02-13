require "http/server"

module HTTP::Protection
  class RemoteReferrer
    include HTTP::Handler

    def initialize(@methods = %w[GET HEAD OPTIONS TRACE])
    end

    def call(context)
      headers = context.request.headers

      return call_next(context) unless headers.has_key?("HTTP_REFERER")

      method = headers["REQUEST_METHOD"]
      referrer = headers["HTTP_REFERER"]

      return false unless referrer.empty? || @methods.includes?(method)
      return false unless URI.parse(referrer).host == context.request.host

      call_next(context)
    end
  end
end
