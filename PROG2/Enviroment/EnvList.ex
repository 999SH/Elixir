defmodule EnvList do


#New list
  def new() do [] end

#Add to list, return key, value pair as list
  def add([], key, value) do
     [{key,value}]
  end
#If map head contains key already, update it with new key value pair as head
  def add([{key,_}|map], key, value) do
    [{key,value}|map]
  end
#Split old list into head and tail, save it and call add method again, if key is found jump to add {key,_}
#else chop off head and try again untill we have an empty list

  def add([head|tail], key, value) do
    [head|add(tail, key,value)]
  end


def lookup([],key) do
  []
end

def lookup([head|tail],key) do
  case {[head|tail],key} do

    {[{^key,_}|_],_} -> head

    _ -> lookup(tail, key)
  end
end


def remove([],_key) do
  []
end

def remove([head|tail],key) do
  case {[head|tail],key} do

    {[{^key,_}|_],_} -> tail

    _ -> [head|remove(tail, key)]
  end
end

end
