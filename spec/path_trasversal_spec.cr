require "./spec_helper"

describe HTTP::Protection::PathTraversal do
  context = context_for_tests
  middleware = HTTP::Protection::PathTraversal.new

  Spec.before_each { context.request.headers.clear }

  it "does not touch /foo/bar" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/foo/bar"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/foo/bar")
  end

  it "does not touch /foo/bar/" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/foo/bar/"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/foo/bar/")
  end

  it "does not touch /" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/")
  end

  it "does not touch /.f" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/.f"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/.f")
  end

  it "does not touch /a.x" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a.x"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/a.x")
  end

  it "replaces /.. with /" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/.."

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/")
  end

  it "replaces /a/../b with /b" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a/../b"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/b")
  end

  it "replaces /a/../b/ with /b/" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a/../b/"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/b/")
  end

  it "replaces /a/. with /a/" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a/."

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/a/")
  end

  it "replaces /%2e. with /" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/%2e."

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/")
  end

  it "replaces /a/%2E%2e/b with /b" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a/%2E%2e/b"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/b")
  end

  it "replaces /a%2f%2E%2e%2Fb/ with /b/" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/a%2f%2E%2e%2Fb/"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/b/")
  end

  it "replaces // with /" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "//"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/")
  end

  it "replaces /%2fetc%2Fpasswd with /etc/passwd" do
    context.request.headers["Content-Type"] = "text/plain"
    context.request.headers["PATH_INFO"] = "/%2fetc%2Fpasswd"

    middleware.call(context)

    context.request.headers["PATH_INFO"].should eq("/etc/passwd")
  end
end
