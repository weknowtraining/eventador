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
        _(arg).must_equal(a)
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
    _(ret).must_equal(2)
  end

  def cbm(a, &block)
    block.callback(:add, a)

    block.callback(:block1, a) +
      block.callback(:block2, a) +
      block.callback(:block3, a)
  end

  it 'should allow many callbacks in sequence' do
    ret = cbm(1) do |on|
      on.add { @flag.notify }
      on.block1 { |a| a * 1 }
      on.block2 { |a| a * 2 }
      on.block3 { |a| a * 3 }
    end
    _(ret).must_equal(6)
  end
end

describe Proc do
  AB = Struct.new(:a, :b)

  def bcb(&block)
    add = block.capture(:add)
    a = 1
    b = 2
    s = AB.new(a, b)
    s.define_singleton_method(:add, &add)
    s.add
  end

  it 'should allow getting the block' do
    ret = bcb do |on|
      on.add { a + b }
    end
    _(ret).must_equal(3)
  end

  def bdb(&block)
    add = block.capture(:add) do
      "default #{a + b}"
    end
    s = AB.new(1, 2)
    s.define_singleton_method(:add, &add)
    s.add
  end

  it 'should allow a default when capturing' do
    ret = bdb do |on|
      on.not_add { a + b }
    end
    _(ret).must_equal('default 3')
  end
end
