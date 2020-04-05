##
# Middleware for protecting against unauthorized access to file system attacks, unescapes '/' and '.' from PATH_INFO.
# http://en.wikipedia.org/wiki/Directory_traversal.
#
# === Examples:
#
#  HTTP::Protection::PathTraversal.new
#
module HTTP::Protection
  class PathTraversal
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      path = context.request.headers["PATH_INFO"] rescue ""
      context.request.headers["PATH_INFO"] = cleanup(path)

      call_next(context)
    end

    def cleanup(path)
      dot = "."
      slash = "/"
      parts = [] of String

      unescaped = path.gsub(/%2e/i, dot).gsub(/%2f/i, slash)

      unescaped.split(slash).each do |part|
        next if part.empty? || part == dot
        part == ".." ? (parts.size > 0 ? parts.pop : nil) : parts << part
      end

      cleaned = slash + parts.join(slash)
      cleaned += slash if parts.any? && unescaped =~ %r{/\.{0,2}$}
      cleaned
    end
  end
end
