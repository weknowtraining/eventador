require 'eventador/version'

module Eventador
  Callback = Struct.new(:args) do
    def method_missing(method, *args, &block)
      false
    end
  end

  def callback(callable, *rest)
    ret = nil
    @callbacks ||= ::Hash.new do |h, method_name|
      h[method_name] = Class.new(Callback) do
        define_method(method_name) do |&block|
          ret = block.nil? ? true : block.call(*args)
        end
        define_method("#{method_name}?") { true }
        define_method(:to_s) { "Callback(#{method_name})" }
      end
    end
    call(@callbacks[callable].new(rest))
    ret
  end
end

class Proc
  include Eventador
end
