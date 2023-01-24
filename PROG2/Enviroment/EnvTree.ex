defmodule EnvTree do

  def new() do
    nil
  end

  def caseadd({:node, currentkey, currentval, leftleaf, rightleaf}, newkey, newvalue) do
    case {{:node, currentkey, currentval, leftleaf, rightleaf}, newkey, newvalue} do
      #Update value
      {{:node, ^currentkey, _, ^leftleaf, ^rightleaf}, ^currentkey, ^newvalue} -> {:node, newkey, newvalue, leftleaf, rightleaf}
      #Add new right leaf
      {{:node, ^currentkey, ^currentval, ^leftleaf, ^rightleaf},^newkey,^newvalue} when newkey < currentkey -> {:node, currentkey, currentval, caseadd(leftleaf, newkey, newvalue), rightleaf}
      #Add new left leaf
      {{:node, ^currentkey, ^currentval, ^leftleaf, ^rightleaf},^newkey,^newvalue} -> {:node, currentkey, currentval, leftleaf, caseadd(rightleaf, newkey, newvalue)}
      #Add leaf/root
      _ -> {:node, newkey, newvalue, nil, nil}
    end

  end



  def add(nil, key, value) do  {:node, key, value, nil, nil} end
  def add({:node, key, _, left, right}, key, value) do {:node, key, value, left, right} end
  def add({:node, k, v, left, right}, key, value) when key < k do {:node, k, v, add(left, key, value), right} end
  def add({:node, k, v, left, right}, key, value) do {:node, k, v, left, add(right, key, value)} end


end
