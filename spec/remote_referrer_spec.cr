require "./spec_helper"

describe HTTP::Protection::RemoteReferrer do
  context = context_for_tests
  middleware = HTTP::Protection::RemoteReferrer.new

  Spec.before_each { context.request.headers.clear }

  it "accepts post requests with no referrer" do
    context.request.headers.add("REQUEST_METHOD", "POST")

    middleware.call(context).should eq(nil)
  end

  it "should allow post request with a relative referrer" do
    context.request.headers.add("REQUEST_METHOD", "POST")
    context.request.headers.add("HTTP_REFERER", "/")

    middleware.call(context).should eq(false)
  end

  it "accepts post requests with the same host in the referrer" do
    context.request.headers.add("REQUEST_METHOD", "POST")
    context.request.headers.add("HTTP_REFERER", "http://example.com/foo")
    context.request.headers.add("HTTP_HOST", "example.com")

    middleware.call(context).should eq(false)
  end

  it "denies post requests with a remote referrer" do
    context.request.headers.add("REQUEST_METHOD", "POST")
    context.request.headers.add("HTTP_REFERER", "http://example.com/foo")
    context.request.headers.add("HTTP_HOST", "example.org")

    middleware.call(context).should eq(false)
  end
end
