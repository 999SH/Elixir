defmodule Calories do
  def calories() do
    File.stream!("input.txt")  #Create a filestream in order to use the text file
    |> Stream.chunk_while(0,
        fn
        "\n", acc -> {:cont, acc, 0}    #Need 0 in order to emit new chunk
          x,  acc -> {:cont, String.to_integer(String.trim(x,"\n")) + acc} #Add calories to current chunk
        end,
        fn acc -> {:cont, []} #Not needed
        end
    )
    |> Enum.sort(:desc)
    |> IO.inspect()
    |> Enum.take(3)
    |> Enum.sum()
  end
end
