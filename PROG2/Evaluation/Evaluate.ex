defmodule Eval do


  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
| {:sub, expr(), expr()}
| {:mul, expr(), expr()}
| {:div, expr(), expr()}
| literal()

def test  do
  env = %{a: -10, b: 2, c: 3, d: 4}
  expr = {:sub,{:div,{:mul, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}},{:q, 6, 3}},{:num,2}},{:var, :a}}

  eval(expr, env)
end

  def eval({:num, n}, _) do n end
  def eval({:var, v}, env) do env[v] end
  def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
  def eval({:div, e1, e2}, env) do dive(eval(e1, env), eval(e2, env)) end
  def eval({:q, n1, n2}, env)     do
    reduced = reduce_fraction({:q, n1, n2})
    eval(reduced,env)
  end

  def add({:q, n, m}, {:q, n2, m2}) do {:q, n*m2 + n2*m, m*m2} end
  def add({:q, n, m}, e2) do {:q, e2*m + n, m} end
  def add(e1, {:q, n, m}) do {:q, e1*m + n, m} end
  def add(e1, e2) do e1 + e2 end

  def sub({:q, n, m}, {:q, x, y}) do {:q, n*y - x*m, m*y} end
  def sub({:q, n, m}, e2) do {:q, e2*m - n, m} end
  def sub(e1, {:q, n, m}) do {:q, e1*m - n, m} end
  def sub(e1, e2) do e1 - e2 end


  def mul({:q, n, m}, {:q, n2, m2}) do {:q, n*n2, m*m2} end
  def mul({:q, n, m}, e1) do {:q, n*e1, m} end
  def mul(e1, {:q, n, m}) do {:q, n*e1, m} end
  def mul(e1, e2) do e1 * e2 end

  def dive({:q, n, m}, {:q, x, y}) do {:q, n*y, m*x} end
  def dive({:q, n, m}, a) do {:q, n, m*a} end
  def dive(e1, {:q, n, m}) do {:q, n, m*e1} end
  def dive(e1, e2) do
    if rem(e1,e2) != 0 do
      {:q, e1, e2}
    end
      div(e1,e2)
  end
  def reduce_fraction({:q, n1, 1}) do
   {:num, n1}
    end
  def reduce_fraction({:q, n1, n2}) do
    gcd = gcd(n1, n2)
    {:q, div(n1,gcd), div(n2,gcd)}
  end

  def gcd(e1, 0) do e1 end
  def gcd(e1, e2) do gcd(e2, rem(e1, e2)) end
end

defmodule Environment do

  def new() do
    %{}
  end


  def fetch(env, key) do
    env[key]
  end
end
