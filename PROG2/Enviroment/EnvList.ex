defmodule EnvList do


#New list
  def new() do [] end

#Add to list
  def add([], key, value) do
     [{key,value}]
  end

  def add([{key,_}|map], key, value) do
    [{key,value}|map]
  end

  def add([head|tail], key, value) do
    [head|add(tail, key,value)]
  end


  def lookup([], _key) do
     nil
    end
  def lookup([{key,_}=kv|_], key) do
    kv
  end

  def lookup([_|map], key) do
    lookup(map, key)
  end

  def remove([], _key) do
    []
  end

  def remove([{key,_}|map], key) do
     map
    end

  def remove([kv|map], key) do
    [kv|remove(map, key)]
  end

end
