alias Num = Int32 | Float64
alias EnvPair = Tuple(Symbol, Num | Closure)
alias Exp = Num | Symbol | Array(Exp)


class Closure
  property exp, env

  def initialize(@exp : Exp, @env : Env)
  end
end


class Env
  def initialize(@env : Array(EnvPair))
  end

  def setenv(env_pair : EnvPair)
    return [env_pair] + @env
  end

  def lookup(variable : Symbol)
    @env.each do |p|
      if p[0] == variable
        return p[1]
      end
    end
    raise "variable is not defined"
  end
end


def interpreter(exp : Exp, env=Env.new([] of EnvPair))
  case exp
  when Num
    return exp
  when Symbol
    return env.lookup(exp)
  when Array
    if exp.size == 3
      f = exp[0] as Symbol
      e1 = exp[1] as Exp
      e2 = exp[2] as Num | Exp
      case f as Symbol
      when :lambda
        return Closure.new(exp, env)
      when :let
        if e1.is_a?(Array)
          pair = e1[0] as Array(Exp)
          key = pair[0] as Symbol
          value = interpreter(pair[1], env) as Num | Closure
          interpreter(e2, Env.new(env.setenv({key, value} as EnvPair)))
        end
      else
        if e1.is_a?(Exp)
          op, v1, v2 = f, interpreter(e1, env) as Num, interpreter(e2, env) as Num
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
    elsif exp.size == 2  # invoke
      v1, v2 = interpreter(exp[0], env) as Closure, interpreter(exp[1], env) as Num
      exp = v1.exp as Array(Exp)
      x = exp[1] as Array(Exp)
      interpreter(exp[2], Env.new(v1.env.setenv({x[0] as Symbol, v2 as Closure | Num})))
    end
  end
end
