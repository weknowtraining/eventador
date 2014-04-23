require 'spec_helper'

describe Proc do
  before do
    @flag = Minitest::Mock.new
    @flag.expect(:notify, :ok)
  end

  after do
    @flag.verify
  end

  def cb(&block)
    block.callback(:test)
  end

  it 'should callback' do
    cb do |on|
      on.test { @flag.notify }
    end
  end

  def cba(a, &block)
    block.callback(:test, a)
  end

  it 'should callback with args' do
    a = Object.new
    cba(a) do |on|
      on.test do |arg|
        @flag.notify
        arg.must_equal(a)
      end
    end
  end

  def cbu(&block)
    block.callback(:test)
    block.callback(:unused)
  end

  it 'should not worry about unhandled callbacks' do
    cbu do |on|
      on.test { @flag.notify }
    end
  end

  def cbr(a, &block)
    block.callback(:add, a)
  end

  it 'should return values' do
    ret = cbr(1) do |on|
      on.add do |a|
        @flag.notify
        a + 1
      end
    end
    ret.must_equal(2)
  end
end
