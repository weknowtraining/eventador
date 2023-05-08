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
end

class Proc
  include Eventador
end
