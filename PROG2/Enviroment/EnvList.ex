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

#If list is empty return nothing
  def lookup([], _key) do
     nil
    end
#If list contains key return key and value

  def lookup([{key,_}=keyval|_], key) do
    keyval
  end

#If list head doesnt contain key, rerun for map-head as list untill list is empty or head contains key
  def lookup([_|map], key) do
    lookup(map, key)
  end

#If list empty return empty list
  def remove([], _key) do
    []
  end
#If list head contains key, return map - head
  def remove([{key,_}|map], key) do
     map
    end
#If list head doesnt contain key, chop off head and try again untill empty list
  def remove([keyval|map], key) do
    [keyval|remove(map, key)]
  end

end
