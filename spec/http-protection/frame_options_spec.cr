require "../spec_helper"

describe HTTP::Protection::FrameOptions do
  context = context_for_tests

  Spec.before_each do
    context.request.headers.clear
    context.response.headers.clear
  end

  it "should set the X-Frame-Options" do
    context.request.headers.add("Content-Type", "text/html")

    middleware = HTTP::Protection::FrameOptions.new
    middleware.next = ->(ctx : HTTP::Server::Context) { called = true }
    middleware.call(context)

    context.response.headers["X-Frame-Options"].should eq("SAMEORIGIN")
  end

  it "should not set the X-Frame-Options for other content types" do
    middleware = HTTP::Protection::FrameOptions.new
    middleware.next = ->(ctx : HTTP::Server::Context) { called = true }
    middleware.call(context)

    context.response.headers.has_key?("X-Frame-Options").should be_false
  end

  it "should allow changing the protection mode" do
    context.request.headers.add("Content-Type", "text/html")

    middleware = HTTP::Protection::FrameOptions.new(option: "DENY")
    middleware.next = ->(ctx : HTTP::Server::Context) { called = true }
    middleware.call(context)

    context.response.headers["X-Frame-Options"].should eq("DENY")
  end

  it "should allow changing the protection mode to a string" do
    context.request.headers.add("Content-Type", "text/html")

    middleware = HTTP::Protection::FrameOptions.new(option: "ALLOW-FROM foo")
    middleware.next = ->(ctx : HTTP::Server::Context) { called = true }
    middleware.call(context)

    context.response.headers["X-Frame-Options"].should eq("ALLOW-FROM foo")
  end

  it "should not override the header if already set" do
    context.request.headers.add("Content-Type", "text/html")
    context.response.headers["X-Frame-Options"] = "allow"

    middleware = HTTP::Protection::FrameOptions.new
    middleware.next = ->(ctx : HTTP::Server::Context) { called = true }
    middleware.call(context)

    context.response.headers["X-Frame-Options"].should eq("allow")
  end
end
