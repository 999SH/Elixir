defmodule Moves do

  def sequence([],state) do [state] end
  def sequence([move|list],state) do
    newstate = single(move, state)
    [state|sequence(list,newstate)]
  end

  def single({move, value},{main, one, two }) do
    case {move, value} do
      {{_x, 0}}                      -> {main, one, two }
      {:one, ^value} when value > 0 -> {Train.drop(main,value), Train.take(main, value) |> Train.append(one), two}
      {:one, ^value}                -> {Train.take(one, value) |> Train.append(main), Train.drop(one,value), two}
      {:two, ^value} when value > 0 -> {Train.drop(main,value), one, Train.take(main, value) |> Train.append(two)}
      {:two, ^value}               ->  {Train.take(two, value) |> Train.append(main), one, Train.drop(two,value)}
      _ -> "Invalid move"
    end
  end
end
