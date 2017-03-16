require "./spec_helper"

describe HTTP::Protection::Deflect do
  context = context_for_tests

  Spec.before_each { context.request.headers.clear }

  it "should allow regular requests to follow through" do
    context.request.headers["REMOTE_ADDR"] = "111.111.111.111"

    middleware = HTTP::Protection::Deflect.new
    middleware.call(context)

    context.response.status_code.should eq(404)
  end

  it "should deflect requests exceeding the request threshold" do
    context.request.headers["REMOTE_ADDR"] = "111.111.111.111"

    middleware = HTTP::Protection::Deflect.new(interval: 10, duration: 10, threshold: 5)

    5.times do
      middleware.call(context)
      context.response.status_code.should eq(404)
    end

    10.times do
      middleware.call(context)
      context.response.status_code.should eq(403)
    end
  end

  it "should expire blocking" do
    context.request.headers["REMOTE_ADDR"] = "111.111.111.111"

    middleware = HTTP::Protection::Deflect.new(interval: 2, duration: 2, threshold: 5)

    5.times do
      middleware.call(context)
      context.response.status_code.should eq(404)
    end

    middleware.call(context)
    context.response.status_code.should eq(403)

    Timecop.freeze(3.seconds.from_now) do
      5.times do
        middleware.call(context)
        context.response.status_code.should eq(404)
      end
    end
  end

  it "should allow whitelisting of remote addresses" do
    context.request.headers["REMOTE_ADDR"] = "222.222.222.222"

    middleware = HTTP::Protection::Deflect.new(interval: 2, threshold: 5, whitelist: ["222.222.222.222"])

    10.times do
      middleware.call(context)
      context.response.status_code.should eq(404)
    end
  end

  it "should allow blacklisting of remote addresses" do
    middleware = HTTP::Protection::Deflect.new(blacklist: ["333.333.333.333"])

    context.request.headers["REMOTE_ADDR"] = "222.222.222.222"

    middleware.call(context)

    context.response.status_code.should eq(404)

    context.request.headers.clear
    context.request.headers["REMOTE_ADDR"] = "333.333.333.333"

    middleware.call(context)

    context.response.status_code.should eq(403)
  end
end
