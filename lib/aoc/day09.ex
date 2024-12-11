defmodule Aoc.Day09 do
  def process_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def expand(list) do
    list
    |> Enum.chunk_every(2, 2, [0])
    |> Enum.with_index()
    |> Enum.map(fn {[a, b], idx} ->
      {List.duplicate(idx, a), b}
    end)
  end

  def move_blocks(list) do
    file =
      list
      |> List.last()
      |> elem(0)

    move_file_block(file, list, [])
  end

  def move_file_block(_f, [], final_list), do: final_list
  def move_file_block(f, [{_a, _b}], final_list), do: final_list ++ [f]

  def move_file_block(f, [{first_file, first_space} | rem_list], final_list)
      when first_space >= length(f) do
    new_list =
      [{first_file ++ f, first_space - length(f)} | rem_list]
      |> Enum.drop(-1)

    move_file_block(new_list |> List.last() |> elem(0), new_list, final_list)
  end

  def move_file_block(f, [{first_file, first_space} | rem_list], final_list)
      when first_space < length(f) do
    move_file_block(
      Enum.take(f, length(f) - first_space),
      rem_list,
      final_list ++ [first_file ++ Enum.take(f, first_space)]
    )
  end

  def checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, idx}, acc -> acc + val * idx end)
  end

  def part1(args) do
    args
    |> process_input()
    |> expand()
    |> move_blocks()
    |> List.flatten()
    |> checksum()
  end

  def move_all_blocks(list, visited \\ :visited) do
    visit_list =
      case visited do
        :visited ->
          list

        :not_visited ->
          list
          |> Enum.map(fn {file, space} -> {file, space, :not_visited} end)
      end

    {action, l} =
      visit_list
      |> Enum.drop(0)
      |> List.foldr({:dont_move, visit_list}, fn {file, _space, visited}, acc ->
        {_, last_list} = acc

        case visited do
          :visited ->
            acc

          _ ->
            case move_all_file(file, [], last_list) do
              {:move, l} ->
                pos = l |> Enum.find_index(fn {f, _, v} -> f == file && v == :not_visited end)
                {_, new_space, _} = l |> Enum.at(pos)

                {:move,
                 l
                 |> List.update_at(pos - 1, fn {f, s, v} ->
                   {f, s + length(file) + new_space, v}
                 end)
                 |> List.delete_at(pos)}

              {:dont_move, l} ->
                pos = l |> Enum.find_index(fn {f, _, _} -> f == file end)

                {:dont_move,
                 l
                 |> List.update_at(pos, fn {f, s, v} -> {f, s, :visited} end)}
            end
        end
      end)

    case action do
      :dont_move -> l
      :move -> move_all_blocks(l, :visited)
    end
  end

  def move_all_file(_file, prefix, []), do: {:dont_move, prefix}

  def move_all_file(file, prefix, [{first_file, first_space, first_visited} | rem_list])
      when length(file) <= first_space and file != first_file,
      do:
        {:move,
         prefix ++
           [
             {first_file, 0, first_visited},
             {file, first_space - length(file), :visited} | rem_list
           ]}

  def move_all_file(
        file,
        prefix,
        list = [{first_file, _first_space, _first_visited} | _rem_list]
      )
      when file == first_file,
      do: {:dont_move, prefix ++ list}

  def move_all_file(file, prefix, [{first_file, first_space, first_visited} | rem_list])
      when length(file) > first_space do
    move_all_file(file, prefix ++ [{first_file, first_space, first_visited}], rem_list)
  end

  def checksum2(list) do
    list
    |> Enum.reduce([], fn {file, space, _}, acc -> acc ++ file ++ List.duplicate(".", space) end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, idx}, acc ->
      case val do
        "." -> acc
        _ -> acc + val * idx
      end
    end)
  end

  def part2(args) do
    args
    |> process_input()
    |> expand()
    |> move_all_blocks(:not_visited)
    |> checksum2()
  end
end
