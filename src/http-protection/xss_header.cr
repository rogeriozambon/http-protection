require "http/server"

##
# Middleware sets X-XSS-Protection header to tell the browser to block attacks.
# http://blogs.msdn.com/b/ie/archive/2008/07/01/ie8-security-part-iv-the-xss-filter.aspx
#
# === Options:
#
#   :xss_mode  How the browser should prevent the attack. Defaults to "block"
#   :nosniff   Blocks a request if the requested type is "style" or "script". Defaults to true
#
# === Examples:
#
#  HTTP::Protection::XSSHeader.new(xss_mode: "block" nosniff: true)
#
module HTTP::Protection
  class XSSHeader
    include HTTP::Handler

    def initialize(@xss_mode : String = "block", @nosniff : Bool = true)
    end

    def call(context)
      content_type = context.request.headers["Content-Type"]

      xss_value = context.request.headers["X-XSS-Protection"] rescue nil
      content_options = context.request.headers["X-Content-Type-Options"] rescue nil

      if allowed_types.includes?(content_type)
        xss_value ||= "1; mode=#{@xss_mode}"
      end

      if @nosniff
        content_options ||= "nosniff"
      end

      context.response.headers["X-XSS-Protection"] = xss_value if xss_value
      context.response.headers["X-Content-Type-Options"] = content_options if content_options
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
