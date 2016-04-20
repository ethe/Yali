alias Num = Int32 | Float64

class Env
  def initialize(@env=[] of Tuple(Symbol, Num | Closure))
  end

  def setenv(x : Symbol, v : Num | Closure)
    return [{x, v}] + @env as Array({Symbol, Num | Closure})
  end

  def lookup(x : Symbol)
    @env.each do |p|
      if p[0] == x
        return p[1]
      end
    end
    raise "not defined"
  end
end


struct Closure
  property exp, env
  def initialize(@exp, @env)
  end
end


def interpreter(exp, env=Env.new)
  case exp
  when Num
    return exp
  when Symbol
    return env.lookup(exp)
  when Array
    f, e1 = exp
    case f
    when :lambda
      return Closure.new(exp, env)
    when :let
      if e1.is_a?(Array)
        pair = e1[0]
        if pair.is_a?(Array)
          x, e = pair[0] as Symbol, pair[1]
          v1 = interpreter(e, env) as Num | Closure
          interpreter(exp[2], Env.new(env.setenv(x, v1)))
        end
      end
    else
      case exp.size
      when 2
        v1, v2 = interpreter(f, env), interpreter(e1, env)
        if v1.is_a?(Closure)
          x = v1.exp[1] as Array(Symbol)
          interpreter(v1.exp[2], Env.new(v1.env.setenv(x[0], v2 as Num)))
        end
      else
        op, v1, v2 = f, interpreter(e1, env) as Num, interpreter(exp[2], env) as Num
        case op
        when :+
          return v1 + v2
        when :-
          return v1 - v2
        when :*
          return v1 * v2
        when :/
          return v1 / v2
        end
      end
    end
  else
    raise "syntax error"
  end
end
