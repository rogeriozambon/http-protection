require "http/server"

module HTTP::Protection
  class IpSpoofing
    include HTTP::Handler

    def call(context)
      headers = context.request.headers

      return true unless headers.has_key?("HTTP_X_FORWARDED_FOR")

      ips = headers["HTTP_X_FORWARDED_FOR"].split(/\s*,\s*/)

      return false if headers.has_key?("HTTP_CLIENT_IP") && !ips.includes?(headers["HTTP_CLIENT_IP"])
      return false if headers.has_key?("HTTP_X_REAL_IP") && !ips.includes?(headers["HTTP_X_REAL_IP"])

      call_next(context)
    end
  end
end
