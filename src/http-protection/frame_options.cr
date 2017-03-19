require "http/server"

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
    include HTTP::Handler

    def initialize(@option : String = "SAMEORIGIN")
    end

    def call(context)
      context.response.headers["X-Frame-Options"] ||= @option if html?(context)
      call_next(context)
    end

    private def html?(context)
      allowed_types.includes?(context.request.headers["Content-Type"])
    rescue
      false
    end

    private def allowed_types
      [
        "text/html",
        "text/html;charset=utf-8",
        "application/xhtml",
        "application/xhtml+xml"
      ]
    end
  end
end
