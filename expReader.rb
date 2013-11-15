expin = gets().to_s

def String.clear()
  self.split("").clear
end

class Calc

  def initialize(exp = nil)
    @exp = exp
    @expout, @problem = "", ""
    @stack, @problems, @problemPoss = [], [], []
    @problemPos = 0
    @funcs, @digits = [], []
  end
  
  def is_a_letter?(object)
    false if (object == ".")
    true if String(object) rescue false
  end
  
  def is_a_digit?(object)
    false if (object == "-")
    true if Float(object) rescue false
  end

  def is_a_function?(string)
    funcs = ["sin", "cos", "+", "-", "/", "*"]
    if funcs.include?(string) then
      true
    else
      false
    end
  end

  def update_problems
    @problems << @problem
    @problem.clear
    @problemPoss << @problemPos
  end
  
  def to_rpn
    #return nil if !(String(@exp))
    
    @exp.chomp!
    @exp.delete! " "
    @exp += " "
    index = 0
    buf = ""
    @exp.split("").each do |sym|
      index += 1
      if is_a_function?(sym) then
        #поймали функцию
        @funcs << sym
        if is_a_digit?(buf) then
          #поймали число
          buf.split("").pop
          @digits << buf
        end
        buf.clear
        #отладка
        update_problems
        next
      end
      if is_a_function?(buf) then
        #поймали функцию
        @funcs << buf
        buf.clear
        #отладка
        update_problems
        next
      else
        #буфер не является функцией 
        if buf != " " then
          @problemPos = index - buf.length
          @problem += sym
        end
        if is_a_digit?(buf) then
          #отладка
          update_problems
          #в буфере неопознанная функция перебилась цифрой
          buf = buf.split("").pop
          next
        end        
=begin
          if is_a_letter?(sym) then
            #поймали число
            buf.split("")[index] = nil
            @digits << buf
            buf.clear
            buf += sym
            #отладка
            update_problems
            next
          end
          
          #поймали число
          buf += sym
          buf.split("")[index] = nil
          @digits << buf
          buf.clear
          #отладка
          update_problems
          next
=end
      end
    end
  
    return @expout
  end
  
  def inf
    print "\nFunctions:\n"
    @funcs.each {|func| print "#{@func} "}
    print "\nNumbers:\n"
    @digits.each {|digit| print "#{@digit} "}
    puts
  end
  
end

calc = Calc.new(expin)
calc.to_rpn
calc.inf

puts

