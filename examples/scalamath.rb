require 'rubygems'
require 'inline'
require '../lib/scala_inline'
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
  
  inline :Scala do |builder|
    builder.package "org.jruby.test"
    builder.scala "
      def factorial_scala(max:Int) = {
        (1 /: 2.to(max)) { (accumulator, next) => accumulator * next }
      }
      "
    builder.scala "
      def fib_scala(n:Int):Int = {
         if (n < 2) n
         else fib_scala(n - 2) + fib_scala(n - 1)
      }
      " 
  end
end

math = FastMath.new

Benchmark.bmbm(30) {|bm|
  5.times { bm.report("factorial_ruby") { 30000.times { math.factorial_ruby(30) } } }
  5.times { bm.report("factorial_scala") { 30000.times { math.factorial_scala(30) } } }
  5.times { bm.report("fib_ruby(35)") { math.fib_ruby(30) } }
  5.times { bm.report("fib_scala(35)") { math.fib_scala(30) } }
}

