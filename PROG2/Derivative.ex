 defmodule Derive do
 #Define types and expressions
 @type literal() :: {:num, number()} | {:var, atom()}

@type expr() :: {:add, expr(), expr()}
               |{:mul, expr(), expr()}
               | literal()

def test() do
  e = {:add, {:mul,{:num,2},{:var,:x}},{:num,4}} #{:pow,{:var, :x},{:num, 3}}
  d = deriv(e, :x)
  s = simplify(d)
  IO.write("Expression: #{pprint(e)}\n")
  IO.write("Derivative: #{pprint(d)}\n")
  IO.write("Simplified: #{pprint(s)}\n")

  :ok
end


#Derivatives ------------------------------------------------
def deriv({:num, _}, _) do {:num,0}
end   #ddx constant = 0

def deriv({:var, v}, v) do {:num,1}
end   #ddx x = 1

def deriv({:var, _}, _) do {:num,0}
end   #ddy x = 0 (x is a constant)

def deriv({:add, e1, e2}, v) do
          {:add, deriv(e1,v), deriv(e2,v)}    #df + dg
 end

def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1,v), e2}, {:mul, e1, deriv(e2,v)}}   #ddx f*g = df*g + dg*f
end

def deriv({:pow, {:var,v},{:num,n}}, v) do
  {:mul, {:num,n}, {:pow, {:var, v}, {:num, n-1}}}
end

#Print--------------------------------------------------------

def pprint({:num, n}) do "#{n}"
end
def pprint({:var, v}) do "#{v}"
end
def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})"
end
def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}"
end
def pprint({:pow, e1, e2}) do "#{pprint(e1)}^#{pprint(e2)}"
end

#Simplify----------------------------------------------------e1

def simplify({:num,n}) do {:num,n} end
def simplify({:var,v}) do {:var,v} end
def simplify({:add,e1,e2}) do
  simplify_add(simplify(e1),simplify(e2))
end
def simplify({:mul,e1,e2}) do
  simplify_mul(simplify(e1),simplify(e2))
end

def simplify({:pow,e1,e2}) do
  simplify_pow(simplify(e1),simplify(e2))
end


def simplify_add({:num,0},e2) do e2 end
def simplify_add(e1,{:num,0}) do e1 end
def simplify_add({:num,n1},{:num,n2}) do {n1+n2} end
def simplify_add(e1,e2) do {:add,e1,e2} end

def simplify_mul({:num,0},e2) do {:num,0} end
def simplify_mul(e1,{:num,0}) do {:num,0} end
def simplify_mul({:num,1},e2) do e2 end
def simplify_mul(e1,{:num,1}) do e1 end
def simplify_mul({:num,n1},{:num,n2}) do {n1*n2} end
def simplify_mul(e1,e2) do {:mul, e1, e2} end

def simplify_pow({:num,0},e2) do {:num,0} end
def simplify_pow(e1,{:num,0}) do {:num,1} end
def simplify_pow(e1,e2) do {:pow, e1,e2} end




end
