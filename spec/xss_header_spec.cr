require "./spec_helper"
require "http/client"

describe HTTP::Protection::XSSHeader do
  context = context_for_tests
  middleware = HTTP::Protection::XSSHeader.new

  Spec.before_each do
    context.request.headers.clear
    context.response.headers.clear
  end

  it "should set the X-XSS-Protection" do
    context.request.headers["Content-Type"] = "text/html"
    middleware.call(context)

    headers = context.response.headers
    headers["X-XSS-Protection"].should eq("1; mode=block")
  end

  it "should set the X-XSS-Protection for XHTML" do
    context.request.headers["Content-Type"] = "application/xhtml+xml"
    middleware.call(context)

    headers = context.response.headers
    headers["X-XSS-Protection"].should eq("1; mode=block")
  end

  it "should not set the X-XSS-Protection for other content types" do
    context.request.headers["Content-Type"] = "application/foo"
    middleware.call(context)

    headers = context.response.headers
    headers.has_key?("X-XSS-Protection").should be_false
  end

  it "should allow changing the protection mode" do
    context.request.headers["Content-Type"] = "application/xhtml"

    HTTP::Protection::XSSHeader.new(xss_mode: "foo").call(context)

    headers = context.response.headers
    headers["X-XSS-Protection"].should eq("1; mode=foo")
  end

  it "should not override the header if already set" do
    context.request.headers["Content-Type"] = "text/html"
    context.request.headers["X-XSS-Protection"] = "0"

    middleware.call(context)

    headers = context.response.headers
    headers["X-XSS-Protection"].should eq("0")
  end

  it "should set the X-Content-Type-Options" do
    context.request.headers["Content-Type"] = "text/html"
    middleware.call(context)

    headers = context.response.headers
    headers["X-Content-Type-Options"].should eq("nosniff")
  end

  it "should set the X-Content-Type-Options for other content types" do
    context.request.headers["Content-Type"] = "application/foo"
    middleware.call(context)

    headers = context.response.headers
    headers["X-Content-Type-Options"].should eq("nosniff")
  end

  it "should allow changing the nosniff-mode off" do
    context.request.headers["Content-Type"] = "text/html"

    HTTP::Protection::XSSHeader.new(nosniff: false).call(context)

    headers = context.response.headers
    headers.has_key?("X-Content-Type-Options").should be_false
  end

  it "should not override the header if already set X-Content-Type-Options" do
    context.request.headers["Content-Type"] = "text/html"
    context.request.headers["X-Content-Type-Options"] = "sniff"

    middleware.call(context)

    headers = context.response.headers
    headers["X-Content-Type-Options"].should eq("sniff")
  end
end
