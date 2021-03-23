module HTTP::Protection
  module Base
    def logger
      Logger.instance
    end

    HTML_CONTENT_TYPES = %w[text/html application/xhtml]

    def html?(context)
      content_type = context.response.headers["Content-Type"]
      HTML_CONTENT_TYPES.any? { |ct| content_type.starts_with? ct }
    rescue
      false
    end

    def origin(context)
      headers = context.request.headers
      headers.fetch("Origin") { nil } || headers.fetch("HTTP_ORIGIN") { nil } || headers.fetch("HTTP_X_ORIGIN") { nil }
    end

    SAFE_METHODS = %w[GET HEAD OPTIONS TRACE]

    def safe?(context)
      SAFE_METHODS.includes?(context.request.method)
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
