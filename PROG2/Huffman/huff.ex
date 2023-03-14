defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
    end

  def text() do
      'this is something that we should encode'
  end
  def stringtext do
    "this is something that we should encode"
end

 #  def test do
 #     sample = sample()
 #     tree = tree(sample)
 #     encode = encode_table(tree)
 #     decode = decode_table(tree)
 #     text = text()
 #     seq = encode(text, encode)
 #     decode(seq, decode)
 #  end
   #def tree(sample) do
      # To implement...
   #end
   #def encode_table(tree) do
      # To implement...
   #end
   #def decode_table(tree) do

      # To implement...
   #end
   #def encode(text, table) do
      # To implement...
   #end
   #def decode(seq, tree) do
  # To implement...
   #end

  def tree(sample) do
    freq(sample)
    |> huffman()

  end

  def freq(sample) do
      freq_map = List.to_string(sample)
      |> String.graphemes()
      |> Enum.reduce(%{}, fn character, map -> Map.update(map, character, 1, fn val -> val+1 end) end)
      |> Enum.sort(fn({_, x}, {_, y}) -> x < y end)
  end


  def huffman([{tree, _}]) do tree end
  def huffman([{character, frequency}, {character2, frequency2} | rest]) do
    huffman(insert({character, frequency}, {character2, frequency2}, rest))
  end

  def insert({character1, frequency1}, {character2, frequency2}, []) do
    [{{character1, character2}, frequency1 + frequency2}]
  end
  def insert({character1, frequency1}, {character2, frequency2}, [{character3, frequency3} | rest]) do
    case {frequency1} do
      _ when frequency1 + frequency2 < frequency3 -> [{{character1, character2}, frequency1 + frequency2}] ++ [{character3, frequency3} | rest]
      _ -> [{character3, frequency3}] ++ insert({character1, frequency1}, {character2, frequency2}, rest)
    end
  end

  def encode_table(tree) do
    Enum.sort(codes(tree, [], []), fn({_,x},{_,y}) -> length(x) < length(y) end)
  end

  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end
  def codes({char1, char2}, path, current) do
    left = codes(char1, [0 | path], current)
    codes(char2, [1 | path], left)
  end
  def codes(char1, code, current) do
    [{char1, Enum.reverse(code)} | current]
  end

  def encode([], _table) do [] end
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end




  def decode_table(tree) do codes(tree, []) end

  def decode([], _), do: []
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}

      nil ->
        decode_char(seq, n + 1, table)
    end
  end



  def read(file, n) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, n)
    File.close(file)

    len = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, len - byte_size(rest)}
      chars ->
        {chars, len}
    end
  end


  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end
end
