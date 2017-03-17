require "./spec_helper"

describe HTTP::Protection::StrictTransport do
  context = context_for_tests

  Spec.before_each do
    context.request.headers.clear
    context.response.headers.clear
  end

  it "should set the Strict-Transport-Security header" do
    middleware = HTTP::Protection::StrictTransport.new
    middleware.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=31536000")
  end

  it "should allow changing the max-age option" do
    middleware = HTTP::Protection::StrictTransport.new(max_age: 16070400)
    middleware.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=16070400")
  end

  it "should allow switching on the include_subdomains option" do
    middleware = HTTP::Protection::StrictTransport.new(include_subdomains: true)
    middleware.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=31536000; includeSubDomains")
  end

  it "should allow switching on the preload option" do
    middleware = HTTP::Protection::StrictTransport.new(preload: true)
    middleware.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=31536000; preload")
  end

  it "should allow switching on all the options" do
    middleware = HTTP::Protection::StrictTransport.new(include_subdomains: true, preload: true)
    middleware.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=31536000; includeSubDomains; preload")
  end
end
