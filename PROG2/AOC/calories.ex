defmodule Calories do

  def calories() do
    File.stream!("input.txt")  #Create a filestream in order to use the text file
    |> IO.inspect()
    |> Stream.map(&String.trim/1) #Required since each line ends with \n in the filestream
    |> Stream.chunk_while(0,
        fn
          "", acc -> {:cont, acc, 0}                     #Need 0 in order to emit chunk
          x,  acc -> {:cont, String.to_integer(x) + acc} #Stores every elf as their own chunk with all cals
        end,
        fn acc -> {:cont, acc, 0}
        end
    )
    |> Enum.sort(:desc)
    |> IO.inspect()
    |> Enum.take(3)
    |> Enum.sum()


  end
end
