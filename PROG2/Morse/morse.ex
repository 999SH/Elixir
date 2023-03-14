defmodule Morse do
  def morse() do
    {:node, :na,
    {:node, 116,
    {:node, 109,
    {:node, 111,
    {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
    {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
    {:node, 103,
    {:node, 113, nil, nil},
    {:node, 122,
    {:node, :na, {:node, 44, nil, nil}, nil},
    {:node, 55, nil, nil}}}},
    {:node, 110,
    {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
    {:node, 100,
    {:node, 120, nil, nil},
    {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
    {:node, 101,
    {:node, 97,
    {:node, 119,
    {:node, 106,
    {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
    nil},
    {:node, 112,
    {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
    nil}},
    {:node, 114,
    {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
    {:node, 108, nil, nil}}},
    {:node, 105,
    {:node, 117,
    {:node, 32,
    {:node, 50, nil, nil},
    {:node, :na, nil, {:node, 63, nil, nil}}},
    {:node, 102, nil, nil}},
    {:node, 115,
    {:node, 118, {:node, 51, nil, nil}, nil},
    {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
    end

    def encode_table() do
      Enum.reduce(codes(morse(), []), %{}, fn({char, code}, acc) ->  #Traslate tree to list to map
        Map.put(acc, char, Enum.reverse(code))
      end)
    end

    def getcode(char) do
      Map.get(encode_table,char)
    end
    def codes(:nil, _) do [] end
    def codes({:node, :na, left, right}, path) do
      codes(left, [45 | path]) ++ codes(right, [46 | path])
    end

    def codes({:node, char, left, right}, path) do
      [{char, path}] ++ codes(left, [45 | path]) ++ codes(right, [46 | path])
    end

    def encode([]) do [] end
    def encode([char | rest]) do
      getcode(char) ++ [32] ++ encode(rest)
    end
    def encode([], acc) do acc end
    def encode([char| rest], acc) do
      encode(rest,getcode(char)++[32]++acc)
    end


    def decode(signal) do
      decode(signal, morse())
    end
    def decode([], _) do [] end
    def decode(signal, table) do
      {char, rest} = decode_char(signal, table)
      [char|decode(rest, table)]
    end

    def decode_char([], {:node, char, _,  _}), do: {char, []}
    def decode_char([45 | signal], {:node, _, long, _}) do
      decode_char(signal, long)
    end
    def decode_char([46 | signal], {:node, _, _, short}) do
      decode_char(signal, short)
    end
    def decode_char([32 | signal], {:node, :na, _, _}) do
      {?*, signal}
    end
    def decode_char([32 | signal], {:node, char, _, _}) do
      {char, signal}
    end
end
