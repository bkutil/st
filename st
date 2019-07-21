#!/usr/bin/env ruby

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
  def initialize(reservoir:)
    @reservoir = reservoir

    @count = 0
    @last = nil
    @sum = 0
    @min = Float::INFINITY
    @max = -Float::INFINITY
    @mean = 0
    @m2 = 0

    @q = { q10: 0.1, q25: 0.25, q50: 0.5, q75: 0.75, q90: 0.9, q99: 0.99 }
  end

  def <<(x)
    @last = x
    @reservoir << x.to_f

    update_values(x.to_f)

    x
  end

  def data
    {
      count: @count,
      sum: @sum,
      min: @min,
      max: @max,
      mean: @mean,
      std: @count.zero? ? @count : @m2 / @count,
      last: @last,
    }.merge(quantiles)
  end

  private

  def quantiles
    data = @reservoir.data.sort

    @q.map do |q, at|
      [q, (at * @reservoir.size).floor]
    end.map do |q, index|
      [q, data[index]]
    end.to_h
  end

  def update_values(x)
    @count += 1

    @sum += x
    @min = x if @min > x
    @max = x if @max < x

    delta = x.to_f - @mean
    delta_n = delta / @count

    @mean += delta_n
    @m2 += (delta * (delta - delta_n))
  end
end

class Output
  def initialize(stream:)
    @s = stream
    @f = %i(last count sum mean std min max q10 q25 q50 q75 q90 q99)
  end

  def to_s
    @f.map { |field| @s.data[field] }.compact.join(",")
  end
end

if $stdin.tty?
  puts <<~EOF
    Usage: echo $RANDOM | st

    st accepts list of numbers, one number per line. The output is a comma separated list of statistics:

    position   statistic
    1          last
    2          count
    3          sum
    4          mean
    5          std
    6          min
    7          max
    8          q10
    9          q25
    10         q50
    11         q75
    12         q90
    13         q99

    last is the input value, q10 to q99 are quantiles.
  EOF

  exit
end

s = Stream.new(reservoir: Reservoir.new)
o = Output.new(stream: s)

ARGF.each_line do |line|
  break if line.nil?
  s << line.strip
  puts o
end
