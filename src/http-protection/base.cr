module HTTP::Protection
  module Base
    def logger
      Logger.instance
    end

    HTML_CONTENT_TYPES = [
      "text/html",
      "application/xhtml",
      "application/xhtml+xml",
    ]

    def html?(context)
      content_type = context.request.headers["Content-Type"]
      HTML_CONTENT_TYPES.any? { |ct| content_type.starts_with? ct }
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
