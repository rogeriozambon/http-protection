require "spec"
require "timecop"
require "../src/http-protection"

HTTP::Protection::Logger.instance = Logger.new(IO::Memory.new)

def context_for_tests : HTTP::Server::Context
  HTTP::Server::Context.new(
    HTTP::Request.new("GET", "/", HTTP::Headers.new),
    HTTP::Server::Response.new(IO::Memory.new)
  )
end
