require 'eventador/version'

module Eventador
  Callback = Struct.new(:args) do
    def method_missing(method, *args, &block)
      false
    end

    def result
      @result
    end
  end

  Capture = Class.new do
    def method_missing(method, *args, &block)
      false
    end

    def block
      @block
    end
  end

  def callback(callable, *rest)
    @callbacks ||= ::Hash.new do |h, method_name|
      h[method_name] = Class.new(Callback) do
        define_method(method_name) do |&block|
          @result = block.nil? ? true : block.call(*args)
        end
        define_method("#{method_name}?") { true }
        define_method(:to_s) { "Callback(#{method_name})" }
      end
    end
    ret = @callbacks[callable].new(rest)
    call(ret)
    ret.result
  end

  def capture(callable)
    @captures ||= ::Hash.new do |h, method_name|
      h[method_name] = Class.new(Capture) do
        define_method(method_name) do |&block|
          @block = block
        end
        define_method("#{method_name}?") { true }
        define_method(:to_s) { "Capture(#{method_name})" }
      end
    end
    ret = @captures[callable].new
    call(ret)
    ret.block
  end
end

class Proc
  include Eventador
end
