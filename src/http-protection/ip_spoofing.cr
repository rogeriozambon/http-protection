require "http/server"

module HTTP::Protection
  class IpSpoofing
    include HTTP::Handler

    def initialize(@header = "HTTP_X_FORWARDED_FOR")
    end

    def call(context)
      headers = context.request.headers

      return true unless headers.has_key?(@header)

      ips = headers[@header].split(/\s*,\s*/)

      return false if headers.has_key?("HTTP_CLIENT_IP") && !ips.includes?(headers["HTTP_CLIENT_IP"])
      return false if headers.has_key?("HTTP_X_REAL_IP") && !ips.includes?(headers["HTTP_X_REAL_IP"])

      call_next(context)
    end
  end
end
