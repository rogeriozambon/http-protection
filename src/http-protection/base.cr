module HTTP::Protection
  class Base
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

      methods.includes?(context.request.headers["REQUEST_METHOD"])
    rescue
      false
    end
  end
end
