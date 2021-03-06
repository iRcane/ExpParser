# -*- coding: utf-8 -*-
class NotExpected < Exception
end

class Operator
  @@operators = {"+" => :left_associative, "-" => :left_associative, \
    "*" => :left_associative, "/" => :left_associative, "^" => :right_associative}
  @@priorities = {"^" => 3, "*" => 2, "/" => 2, "-" => 1, "+" => 1}
  
  def initialize(char)
    if @@operators.include?(char)
      @operator = char
      @association = @@operators[char]
      @priority = @@priorities[char]
    else
      raise NotExpected.new("Unknown operator: #{char}")
    end
  end

  def self.is_operator?(char)
    return result = if @@operators.include?(char)
                      true
                    else
                      false
                    end
  end
  
  def priority
    @priority
  end
  
  def association
    @association
  end
  
  def operator
    @operator
  end
  
  def ==(x)
    return result = if @operator == x 
                      true
                    else
                      false
                    end
  end
  
  def to_str
    return @operator
  end
end

class Function
  @@functions = {"sin" => :fd}
  
  def initialize(string)
    if @@functions.include?(string)
      @function = string
    else
      raise NotExpected.new("Unknown function: #{string}")
    end
  end
  
  def self.is_function?(string)
    return result = if @@functions.include?(string)
                      true
                    else
                      false
                    end
  end
  
  def function
    @function
  end
  
  def priority
    0
  end

  def ==(x)
    return result = if @function == x
                      true
                    else
                      false
                    end
  end
end

class Bracket
  @@brackets = ["(", ")"]
  
  def initialize(char)
    if @@brackets.include?(char)
      @bracket = char
    else
      raise NotExpected.new("Unknown bracket: #{char}")
    end
  end
  
  def self.is_bracket?(char)
    return result = if @@brackets.include?(char)
                      true
                    else
                      false
                    end
  end
  
  def bracket
    @bracket
  end
  
  def priority
    return 0
  end
  def ==(x)
    return result = if @bracket == x
                      true
                    else
                      false
                    end
  end
end

class Expression
  def initialize(exp)
    @exp = exp.chomp.delete " "
    @stack = []
    @output = []
  end

  def to_rpn
    index = 0
    while @exp[index] != nil
      x = tokenize(index)
      case x[:type]
      when :operator
        if not @stack.empty?
          if x[:token].association == :right_associative
            while x[:token].priority < @stack.last()[:token].priority
              @output << @stack.pop
              break if @stack.last == nil
            end
          else
            while x[:token].priority <= @stack.last()[:token].priority
              @output << @stack.pop
              break if @stack.last == nil
            end
          end
        end
        @stack << x
      when :function
        @stack << x
      when :bracket
        if x[:token] == '('
          @stack << x
        else
          until @stack.last()[:token] == '(' do
            @output << @stack.pop
            if @stack.last == nil
              raise NotExpected.new("Brackets mismatch occured")
              break
            end
          end
          if @stack.last()[:token] == '('
            @stack.pop
          end
        end
      when :num
        @output << x
      else
        p "Unknown tokenize() result"
      end
      index = x[:index]
    end
    while not @stack.empty?
      @output << @stack.pop
    end
    return @output
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
    if Bracket.is_bracket?(buf)
      return {:token => Bracket.new(buf), :type => :bracket, :index => i}
    end
    
    if ('a'..'z').include?(buf[-1])
      until Operator.is_operator?(@exp[i]) or 
            Bracket.is_bracket?(@exp[i]) or
            ('0'..'9').include?(@exp[i]) or
            @exp[i] == nil
        buf << @exp[i]
        i += 1
      end
      return {:token => Function.new(buf), :type => :function, :index => i}
    end
    
    if ('0'..'9').include?(buf[-1])
      until Operator.is_operator?(@exp[i]) or 
            Bracket.is_bracket?(@exp[i]) or
            ('a'..'z').include?(@exp[i]) or
            @exp[i] == nil
        buf << @exp[i]
        i += 1
      end
      return {:token => Integer(buf), :type => :num, :index => i}
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
    exp_in_rpn = expression.to_rpn
    exp_in_rpn.each do |token|
    if token.class == Function
      case token.function
      when "sin"
        @stack << Math.sin(@stack.reverse.pop)
      end
      next
    end
    if token.class == Operator
      case token.operator
      when "+"
      @stack << @stack.reverse.pop + @stack.reverse.pop
      when "-"
      @stack << @stack.reverse.pop - @stack.reverse.pop
      when "*"
      @stack << @stack.reverse.pop * @stack.reverse.pop
      when "/"
      @stack << @stack.reverse.pop / @stack.reverse.pop
      when "^"
      @stack << @stack.reverse.pop ** @stack.reverse.pop
      end
      next
    end
    @stack << token.to_s
    end
      end
    end

calc = Calc.new
calc.run
