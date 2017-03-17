require "http/server"

module HTTP::Protection
  class StrictTransport
    include HTTP::Handler

    def initialize(@max_age : Int32 = 31536000, @include_subdomains : Bool = false, @preload : Bool = false)
    end

    def call(context)
      context.response.headers["Strict-Transport-Security"] ||= strict_transport
      call_next(context)
    end

    private def strict_transport
      "max-age=#{@max_age.to_s}#{include_subdomains_option}#{preload_option}"
    end

    private def include_subdomains_option
      "; includeSubDomains" if @include_subdomains
    end

    private def preload_option
      "; preload" if @preload
    end
  end
end
