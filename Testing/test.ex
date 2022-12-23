defmodule Test do
  def double(n) do
    n = n*2
  end
  def convertToFar(n) do
    n = n*1.8 + 32
  end
  def convertToCel(n) do
    n = (n-32)*(5/9)
  end
  def calculateRectangleArea(x,y) do
    x = x * y
  end
  def caseStatement(n) do
    cond do
      n == 1 -> "Succesfull test"
      n != 1 -> "Unsuccessfull test"
    end
  end
end
