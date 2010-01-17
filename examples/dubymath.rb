require 'rubygems'
require 'inline'
require 'duby_inline'
require 'benchmark'

class FastMath
  def factorial_ruby(n)
    f = 1
    n.downto(2) { |x| f *= x }
    return f
  end

  def fib_ruby(n)
    if n < 2
      n
    else
      fib_ruby(n - 2) + fib_ruby(n - 1)
    end
  end
  
  inline :Duby do |builder|
    builder.duby "
      def factorial_duby(max:int)
        i = max
        result = 1
        while i >= 2; result *= i-=1; end
        result
      end
      "

    builder.duby "
      def fib_duby(n:int)
        if n < 2
          n
        else
          fib_duby(n - 2) + fib_duby(n - 1)
        end
      end
      "
  end
end

math = FastMath.new

Benchmark.bmbm(30) {|bm|
  5.times { bm.report("factorial_ruby") { 30000.times { math.factorial_ruby(30) } } }
  5.times { bm.report("factorial_duby") { 30000.times { math.factorial_duby(30) } } }
  5.times { bm.report("fib_ruby(35)") { math.fib_ruby(30) } }
  5.times { bm.report("fib_duby(35)") { math.fib_duby(30) } }
}

