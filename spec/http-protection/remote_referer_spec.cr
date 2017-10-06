require "../spec_helper"

describe HTTP::Protection::RemoteReferer do
  context = context_for_tests
  middleware = HTTP::Protection::RemoteReferer.new

  Spec.before_each { context.request.headers.clear }

  it "accepts post requests with no referer" do
    context.request.method = "POST"

    middleware.call(context)
    context.response.status_code.should eq(404)
  end

  it "accepts post requests with the same host in the referer" do
    context.request.method = "POST"
    context.request.headers.add("Referer", "http://example.com/foo")
    context.request.headers.add("Host", "example.com")

    middleware.call(context)

    context.response.status_code.should eq(403)
  end

  it "denies post requests with a remote referer" do
    context.request.method = "POST"
    context.request.headers.add("Referer", "http://example.com/foo")
    context.request.headers.add("Host", "example.org")

    middleware.call(context)

    context.response.status_code.should eq(403)
  end
end
