#!/usr/bin/env ruby

require 'json'

class Reservoir
  attr_reader :data

  def initialize(capacity: 2**10)
    @data = []
    @capacity = capacity
    @n = 0
    @g = Random.new
  end

  def size
    [@n, @capacity].min
  end

  def <<(x)
    @n += 1

    if @n <= @capacity
      @data.push(x)
    else
      # TIL: rand(range) -> inclusive
      s = @g.rand(0..@n)
      @data[s] = x if s < @capacity
    end
  end
end

class Stream
  attr_reader :last

  def initialize(reservoir:)
    @reservoir = reservoir
  end

  def <<(x)
    @last = x
    @last_f = x.to_f

    @reservoir << @last_f
    init_values(@last_f) if @n.nil?
    update_values(@last_f)

    x
  end

  def to_s
    JSON.pretty_generate(
      count: @n,
      sum: @sum,
      min: @min,
      max: @max,
      mean: @mean,
      std: @m2 / @n,
      q: quantiles.zip(@reservoir.data.sort.values_at(*percentiles)).to_h
    )
  end

  private

  def quantiles
    [0.1, 0.25, 0.5, 0.75, 0.9, 0.99]
  end

  def percentiles
    quantiles.map { |q| (q * @reservoir.size).floor }
  end

  def update_values(x)
    @n += 1

    @sum += x
    @min = x if @min > x
    @max = x if @max < x

    delta = x - @mean
    delta_n = delta / @n

    @mean += delta_n
    @m2 += (delta * (delta - delta_n))
  end

  def init_values(x)
    @n = 0
    @sum = 0
    @min = x
    @max = x
    @mean = 0
    @m2 = 0
  end
end

class Output
  def initialize(stream:)
    @t = Time.now
    @s = stream
    @tty = $stdout.tty?
  end

  def first
    clear unless @tty
  end

  def last
    clear unless @tty
    print
  end

  def next
    puts @s.last

    return if @tty
    return if (Time.now - @t).to_f < 0.2

    clear
    print

    @t = Time.now
  end

  private

  def print
    $stderr.printf @s.to_s
  end

  def clear
    $stderr.printf "\033[2J"
    $stderr.printf "\033[1;1H"
  end
end

s = Stream.new(reservoir: Reservoir.new)
o = Output.new(stream: s)

o.first

ARGF.each_line do |line|
  break if line.nil?
  s << line.strip
  o.next
end

o.last
