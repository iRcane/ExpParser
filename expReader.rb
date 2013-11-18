# -*- coding: utf-8 -*-
class NotAnOperator < Exception
end

class Operator
  @@operators = {"+" => :left_associative, "-" => :left_associative, \
    "*" => :left_associative, "/" => :left_associative, "^" => :right_associative}
  
  def initialize(char)
    if @@operators.include?(char)
      @operator = char
      @association = @@operators[char]
    else
      raise NotAnOperator.new("Unknown operator: #{char}")
    end
  end

  def self.is_operator?(char)
    return result = if @@operators.include?(char)
                      true
                    else
                      false
                    end
  end
 
  def association
    @association
  end
end

class Function
  functions = {"sin" => :fd}
end

class Expression
  def initialize(exp)
    @exp = exp.chomp.delete " "
    @stack = []
    @output = ""
  end

  def to_rpn
    p @exp
    index = 0
    while @exp[index] != nil
      x = tokenize(index)
      p x.to_s
      case x[:type]
      when :operator
        @stack << x[:token]
      when :num
        @output << x[:token]
      else
        p "Unknown tokenize() result"
      end
      index = x[:index]
    end

    p "#{@stack.to_s} - #{@output}"
  end
  
  private
  def tokenize(index)
    buf = ""
    i = index

    buf << @exp[i]
    i += 1
    if Operator.is_operator?(buf)
      return {:token => Operator.new(buf), :type => :operator, :index => i}
    end

    if Integer(buf)
      until Operator.is_operator?(@exp[i]) or @exp[i] == nil
        buf << @exp[i]
        i += 1
      end
      return {:token => Integer(buf), :type => :num,:index => i}
    end
  end
end

class Calc

  def initialize(exp = nil)
    @expout = ""
    @stack = []
  end
 
  def run
    exp = gets.to_s
    expression = Expression.new(exp)
    expression.to_rpn
  end
end

calc = Calc.new
calc.run
