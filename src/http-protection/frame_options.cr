require "http/server"

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
