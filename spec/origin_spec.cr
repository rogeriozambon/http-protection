require "./spec_helper"

describe HTTP::Protection::Origin do
  context = context_for_tests

  Spec.before_each do
    context.request.headers.clear
    context.response.headers.clear
  end

  %w(GET HEAD POST PUT DELETE).each do |method|
    it "accepts #{method} requests with no origin" do
      context.request.headers.add("REQUEST_METHOD", method)

      middleware = HTTP::Protection::Origin.new
      middleware.call(context)

      context.response.status_code.should eq(404)
    end
  end

  %w(GET HEAD).each do |method|
    it "accepts #{method} requests with non-whitelisted origin" do
      context.request.headers.add("HTTP_ORIGIN", "http://malicious.com")
      context.request.headers.add("REQUEST_METHOD", method)

      middleware = HTTP::Protection::Origin.new
      middleware.call(context)

      context.response.status_code.should eq(404)
    end
  end

  %w(POST PUT DELETE).each do |method|
    it "denies #{method} requests with non-whitelisted origin" do
      context.request.headers.add("HTTP_ORIGIN", "http://malicious.com")
      context.request.headers.add("REQUEST_METHOD", method)

      middleware = HTTP::Protection::Origin.new
      middleware.call(context)

      context.response.status_code.should eq(403)
    end

    it "accepts #{method} requests with whitelisted origin" do
      context.request.headers.add("HTTP_ORIGIN", "http://www.friend.com")
      context.request.headers.add("REQUEST_METHOD", method)

      middleware = HTTP::Protection::Origin.new(whitelist: ["http://www.friend.com"])
      middleware.call(context)

      context.response.status_code.should eq(404)
    end
  end
end
