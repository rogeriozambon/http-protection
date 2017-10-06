module HTTP::Protection
  module Base
    def logger
      Logger.instance
    end

    def html?(context)
      content_types = [
        "text/html",
        "text/html;charset=utf-8",
        "application/xhtml",
        "application/xhtml+xml",
      ]

      content_types.includes?(context.request.headers["Content-Type"])
    rescue
      false
    end

    def origin(context)
      headers = context.request.headers
      headers.fetch("Origin") { nil } || headers.fetch("HTTP_ORIGIN") { nil } || headers.fetch("HTTP_X_ORIGIN") { nil }
    end

    def safe?(context)
      methods = [
        "GET",
        "HEAD",
        "OPTIONS",
        "TRACE",
      ]

      methods.includes?(context.request.method)
    rescue
      false
    end

    def forbidden(context)
      context.response.headers["Content-Type"] = "text/plain"
      context.response.headers["Content-Length"] = "0"
      context.response.status_code = 403
      context.response.close
    end
  end
end
