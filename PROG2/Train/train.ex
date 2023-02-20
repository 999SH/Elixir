defmodule Train do
  def take(xs, n) do
    Enum.take(xs, n)
  end
  def drop(xs , n) do
    Enum.drop(xs ,n)
  end
  def append(xs, ys) do
    Enum.concat(xs, ys)
  end
  def member(xs, y) do
    Enum.member?(xs, y)
  end
  def position(xs, y) do
    Enum.find_index(xs, fn x -> x == y end)+1
  end
  def split(xs, y) do
    List.delete(xs, y)
    |> Enum.split(position(xs ,y)-1)
  end
end

defmodule Moves do
  def sequence([],state) do [state] end
  def sequence([move|list],state) do
    newstate = single(move, state)
    [state|sequence(list,newstate)]
  end

  def single({move, value},{main, one, two}) do
    case {move, value} do
      {{_x, 0}} -> {main, one, two }
      {:one, ^value} when value > 0 -> {Train.drop(main,value), Train.take(main, value) |> Train.append(one), two}
      {:one, ^value}                -> {Train.take(one, value) |> Train.append(main), Train.drop(one,value), two}
      {:two, ^value} when value > 0 -> {Train.drop(main,value), one, Train.take(main, value) |> Train.append(two)}
      {:two, ^value}                -> {Train.take(two, value) |> Train.append(main), one, Train.drop(two,value)}
      _ -> 'Invalid move'
    end
  end
end

defmodule Shunt do
  def find(_,[]) do [] end
  def find(xs, [element|ys]) do
    {front, back} = Train.split(xs, element)
    [{:one, length(back)+1}, {:two, length(front) }, {:one, -(length(back)+1)}, {:two, -length(front)} | find(Train.append(front, back), ys)]
    end
  def few(_,[]) do [] end
  def few([xshead|xstail], [element|ys]) do
    {front, back} = Train.split([xshead|xstail], element)
    case {xshead, element} do
      {^xshead, ^xshead} -> few(xstail,ys)
      _->  [{:one, length(back)+1}, {:two, length(front) }, {:one, -(length(back)+1)}, {:two, -length(front)} | few(Train.append(front, back), ys)]
    end
  end

  def rules([]) do [] end
  def rules([{move,value}|[]]) do
    case {value} do
      {0} -> []
      {value} -> [{move,value}]
    end
  end
  def rules([{move,value}|[{move2, value2}|list]]) do
    case {move, value+value2} do
      {_x,0} -> rules(list)
      {^move2, _} -> [{move, value+value2}|rules(list)]
      _-> [move,value|rules([{move2, value2}|list])]
    end
  end


  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
    ms
    else
    compress(ns)
    end
    end
end
