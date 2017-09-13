module HTTP::Protection
  class Logger
    class_property instance : ::Logger = ::Logger.new(STDOUT)
    @@instance.level = ::Logger::WARN
  end
end
