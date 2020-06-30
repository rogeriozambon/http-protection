module HTTP::Protection
  class Logger
    class_property instance : Log = Log.new(source: "http.protection", backend: Log::IOBackend.new, level: :warn)
  end
end
