defmodule Carlos do
  def dart(r) do
    r2 = :math.pow(r,2)
    x2 = :math.pow(Enum.random(0..r),2)
    y2 = :math.pow(Enum.random(0..r),2)

    x2+y2 < r2
   end


   def round(0, n, a) do (4*a/n) end
   def round(k, n, a)do
    if dart(10*n) do
      round(k-1, n, a+1)
    else
      round(k-1, n, a)
    end
  end

  def test(0, _n) do "Done" end
  def test(rounds, n) do
    pi = round(n, n, 0)
    :io.format(" n = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [n, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    test(rounds-1, n*2)
  end
end
