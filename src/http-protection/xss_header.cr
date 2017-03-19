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
  class XSSHeader < Base
    include HTTP::Handler

    def initialize(@xss_mode : String = "block", @nosniff : Bool = true)
    end

    def call(context)
      xss_value = context.request.headers["X-XSS-Protection"] rescue nil
      content_options = context.request.headers["X-Content-Type-Options"] rescue nil

      if html?(context)
        xss_value ||= "1; mode=#{@xss_mode}"
      end

      if @nosniff
        content_options ||= "nosniff"
      end

      context.response.headers["X-XSS-Protection"] = xss_value if xss_value
      context.response.headers["X-Content-Type-Options"] = content_options if content_options
    end
  end
end
