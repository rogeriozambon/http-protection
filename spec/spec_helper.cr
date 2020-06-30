require "spec"
require "timecop"
require "../src/http-protection"

HTTP::Protection::Logger.instance = Log.new(source: "http.protection", backend: Log::MemoryBackend.new, level: :warn)

def context_for_tests : HTTP::Server::Context
  HTTP::Server::Context.new(
    HTTP::Request.new("GET", "/", HTTP::Headers.new),
    HTTP::Server::Response.new(IO::Memory.new)
  )
end
