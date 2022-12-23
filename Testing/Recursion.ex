defmodule Recursion do
  def prod(m, n) do
    cond do
      m > 0 ->
        prod(m - 1,n) + n
      m == 0 ->
        0
    end
  end

  def prodcase(m,n) do
    case 0 do
      ^m ->
         0
      _ ->
        prodcase(m - 1,n) + n
    end
  end

  def proddef(0,_n) do
    0
  end
  def proddef(m,n) do
    proddef(m-1,n) + n
  end
end
