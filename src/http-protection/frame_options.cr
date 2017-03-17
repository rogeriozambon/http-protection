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
      ["text/html", "application/xhtml"].includes?(context.request.headers["Content-Type"])
    rescue
      false
    end
  end
end
