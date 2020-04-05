##
# Middleware for protecting against Denial-of-service attacks.
# http://en.wikipedia.org/wiki/Denial-of-service_attack.
#
# === Options:
#
#   :interval   Duration in seconds until the request counter is reset. Defaults to 5
#   :duration   Duration in seconds that a remote address will be blocked. Defaults to 900 (15 minutes)
#   :threshold  Number of requests allowed. Defaults to 100
#   :blacklist  Array of remote addresses immediately considered malicious.
#   :whitelist  Array of remote addresses which bypass Deflect.
#
# === Examples:
#
#  HTTP::Protection::Deflect.new(interval: 5, duration: 5, threshold: 10, blacklist: ["111.111.111.111"], whitelist: ["222.222.222.222"])
#
module HTTP::Protection
  class Deflect
    include Base
    include HTTP::Handler

    def initialize(@interval : Int32 = 5, @duration : Int32 = 900, @threshold : Int32 = 100, @blacklist : Array(String) = [] of String, @whitelist : Array(String) = [] of String)
      @mutex = Mutex.new

      @mapper = {} of String => Hash(String, Int32 | Int64)
      @remote = ""
    end

    def call(context : HTTP::Server::Context)
      return call_next(context) unless deflect?(context)

      forbidden(context)
    end

    private def deflect?(context)
      @remote = context.request.headers["REMOTE_ADDR"]

      return false if whitelisted?
      return true if blacklisted?

      @mutex.synchronize { watch }
    end

    private def map
      @mapper[@remote] ||= {
        "expires"  => Time.utc.to_unix + @interval,
        "requests" => 0,
      }
    end

    private def watch
      increment_requests

      clear! if watch_expired? && !blocked?
      clear! if blocked? && block_expired?
      block! if watching? && exceeded_request_threshold?

      blocked?
    end

    private def blacklisted?
      @blacklist.includes?(@remote)
    end

    private def whitelisted?
      @whitelist.includes?(@remote)
    end

    private def block!
      return if blocked?

      map["block_expires"] = Time.utc.to_unix + @duration

      logger.warn("#{@remote} blocked")
    end

    private def clear!
      return unless watching?

      @mapper.delete(@remote)

      logger.warn("#{@remote} released") if blocked?
    end

    private def blocked?
      map.has_key?("block_expires")
    end

    private def block_expired?
      map["block_expires"] < Time.utc.to_unix rescue false
    end

    private def watching?
      @mapper.has_key?(@remote)
    end

    private def increment_requests
      map["requests"] += 1
    end

    private def watch_expired?
      map["expires"] <= Time.utc.to_unix
    end

    private def exceeded_request_threshold?
      map["requests"] > @threshold
    end
  end
end
