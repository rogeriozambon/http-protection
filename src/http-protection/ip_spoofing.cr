##
# Middleware for detecting IP spoofing attacks.
# http://blog.c22.cc/2011/04/22/surveymonkey-ip-spoofing.
#
# === Examples:
#
#  HTTP::Protection::IpSpoofing.new
#
module HTTP::Protection
  class IpSpoofing
    include Base
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      headers = context.request.headers

      return call_next(context) unless headers.has_key?("X-Forwarded-For")

      ips = headers["X-Forwarded-For"].split(/\s*,\s*/)

      return forbidden(context) if headers.has_key?("X-Client-IP") && !ips.includes?(headers["X-Client-IP"])
      return forbidden(context) if headers.has_key?("X-Real-IP") && !ips.includes?(headers["X-Real-IP"])

      call_next(context)
    end
  end
end
