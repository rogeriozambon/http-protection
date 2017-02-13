require "./spec_helper"

describe HTTP::Protection::IpSpoofing do
  context = context_for_tests
  middleware = HTTP::Protection::IpSpoofing.new

  Spec.before_each { context.request.headers.clear }

  it "accepts requests without X-Forward-For header" do
    middleware.call(context).should eq(true)
  end

  it "accepts requests with proper X-Forward-For header" do
    context.request.headers.add("HTTP_CLIENT_IP", "1.2.3.4")
    context.request.headers.add("HTTP_X_FORWARDED_FOR", "192.168.1.20, 1.2.3.4, 127.0.0.1")

    middleware.call(context).should eq(nil)
  end

  it "denies requests where the client spoofs X-Forward-For but not the IP" do
    context.request.headers.add("HTTP_CLIENT_IP", "1.2.3.4")
    context.request.headers.add("HTTP_X_FORWARDED_FOR", "1.2.3.5")

    middleware.call(context).should eq(false)
  end

  it "denies requests where the client spoofs the IP but not X-Forward-For" do
    context.request.headers.add("HTTP_CLIENT_IP", "1.2.3.5")
    context.request.headers.add("HTTP_X_FORWARDED_FOR", "192.168.1.20, 1.2.3.4, 127.0.0.1")

    middleware.call(context).should eq(false)
  end

  it "denies requests where IP and X-Forward-For are spoofed but not X-Real-IP" do
    context.request.headers.add("HTTP_CLIENT_IP", "1.2.3.5")
    context.request.headers.add("HTTP_X_FORWARDED_FOR", "1.2.3.5")
    context.request.headers.add("HTTP_X_REAL_IP", "1.2.3.4")

    middleware.call(context).should eq(false)
  end
end
