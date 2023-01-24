defmodule EnvTree do

  def new() do
    nil
  end

  #root/leaf
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  def add({:node, currentkey, currentval, leftleaf, rightleaf}, newkey, newvalue) do
    case {newkey, currentkey} do
      {^currentkey, ^currentkey} -> {:node, currentkey, newvalue, leftleaf, rightleaf}
      _ when newkey < currentkey  -> {:node, currentkey, currentval, add(leftleaf, newkey, newvalue), rightleaf}
      _ -> {:node, currentkey, currentval, leftleaf, add(rightleaf, newkey, newvalue)}
    end
  end

  def lookup(nil, _key) do
    nil
  end

  def lookup({:node, currentkey, currentval, leftleaf, rightleaf}, key) do
    cond do
      key == currentkey -> {currentkey,currentval}
      key < currentkey -> lookup(leftleaf,key)
      true -> lookup(rightleaf,key)
    end
  end

  def remove(nil, _key) do
    nil
  end

  def remove({:node, currentkey, currentval, leftleaf, rightleaf}, key) do
    case {:node, currentkey, currentval, leftleaf, rightleaf} do

      {:node, ^key, _, nil, nil} -> nil
      {:node, ^key, _, nil, ^rightleaf} -> rightleaf
      {:node, ^key, _, ^leftleaf, nil} -> leftleaf
      {:node, ^key, _, ^leftleaf, ^rightleaf} ->
        {key, value, oright} = leftmost(rightleaf)
        {:node, key, value, leftleaf, oright}
      {:node, ^currentkey, _, ^leftleaf, ^rightleaf} when key < currentkey -> {:node, currentkey, currentval, remove(leftleaf,key), rightleaf}
      {:node, ^currentkey, _, ^leftleaf, ^rightleaf} -> {:node, currentkey, currentval, remove(leftleaf,key), remove(rightleaf,key)}
      _-> "Key not found"

    end
  end

  def leftmost({:node, key, value, mleft, mright}) do
    case {mleft} do
      {nil} -> {key, value, mright}
      _ ->
        {key2, value2 , oright} = leftmost(mleft)
        {key2, value2, {:node, key, value, oright, mright}}
    end
  end
end
