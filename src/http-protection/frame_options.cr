##
# Middleware for protecting against clickjacking, setting header to tell the browser avoid embedding the page in a frame.
# https://developer.mozilla.org/en/The_X-FRAME-OPTIONS_response_header.
#
# === Options:
#
#   :option  Defines who should be allowed to embed the page in a frame. Use "DENY" or "SAMEORIGIN". Defaults to "SAMEORIGIN"
#
# === Examples:
#
#  HTTP::Protection::FrameOptions.new(option: "SAMEORIGIN")
#
module HTTP::Protection
  class FrameOptions
    include Base
    include HTTP::Handler

    def initialize(@option : String = "SAMEORIGIN")
    end

    def call(context : HTTP::Server::Context)
      context.response.headers["X-Frame-Options"] ||= @option if html?(context)
      call_next(context)
    end
  end
end
