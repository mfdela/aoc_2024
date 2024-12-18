defmodule Aoc.Day15 do
  def process_input(input) do
    [m, s] =
      input
      |> String.split("\n\n", trim: true)

    map =
      m
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {val, c} -> {{r, c}, val} end)
      end)
      |> Map.new()

    seq =
      s
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> List.flatten()

    {map, seq}
  end

  def next_pos({r, c}, move) do
    case move do
      "^" -> {r - 1, c}
      "v" -> {r + 1, c}
      "<" -> {r, c - 1}
      ">" -> {r, c + 1}
    end
  end

  def move(map, {_r, _c}, []), do: map

  def move(map, {r, c}, [next_move | rest_move]) do
    next_pos = next_pos({r, c}, next_move)
    next_val = Map.get(map, next_pos)

    {move_boxes, next_p} =
      cond do
        next_val == "#" ->
          {[], {r, c}}

        next_val == "." ->
          {[], next_pos}

        next_val == "O" ->
          case move_boxes(map, next_pos, next_move, [next_pos]) do
            {:nok, []} -> {[], {r, c}}
            {:ok, l} -> {l, next_pos}
          end

        (next_val == "[" || next_val == "]") && (next_move == ">" || next_move == "<") ->
          case move_boxes(map, next_pos, next_move, [next_pos]) do
            {:nok, []} -> {[], {r, c}}
            {:ok, l} -> {l, next_pos}
          end

        next_move == "^" || next_move == "v" ->
          case move_boxes_vert(map, pair(map, next_pos), next_move, pair(map, next_pos)) do
            {:nok, []} -> {[], {r, c}}
            {:ok, l} -> {l, next_pos}
          end
      end

    Enum.reduce(move_boxes, map, fn {rr, cc}, acc ->
      # IO.inspect(Map.get(map, {rr, cc}, label: "from map get #{rr}, #{cc}"))
      # IO.inspect(next_pos({rr, cc}, next_move), label: "to")

      Map.put(acc, next_pos({rr, cc}, next_move), Map.get(map, {rr, cc}))
      |> Map.put({rr, cc}, ".")
    end)
    |> move(next_p, rest_move)
  end

  def move_boxes(map, {r, c}, dir, moving_boxes) do
    next_pos = next_pos({r, c}, dir)
    next_val = Map.get(map, next_pos)

    cond do
      next_val == "#" ->
        {:nok, []}

      next_val == "." ->
        {:ok, moving_boxes}

      next_val == "O" || next_val == "[" || next_val == "]" ->
        move_boxes(map, next_pos, dir, [next_pos | moving_boxes])
    end
  end

  def draw(map, {r, c} \\ {0, 0}) do
    Map.put(map, {r, c}, "@")
    |> Enum.sort()
    |> Enum.reduce("", fn {{_r, c}, v}, acc ->
      if c == 0 do
        acc <> "\n"
      else
        acc
      end <> v
    end)
  end

  def gps(map) do
    Enum.reduce(map, 0, fn {{r, c}, v}, acc ->
      case v do
        "O" ->
          acc + 100 * r + c

        "[" ->
          acc + 100 * r + c

        _ ->
          acc
      end
    end)
  end

  def part1(args) do
    {map, seq} =
      args
      |> process_input()

    start = Enum.find(map, fn {_, v} -> v == "@" end) |> elem(0)

    move(Map.put(map, start, "."), start, seq)
    |> gps()
  end

  def transform(map) do
    map
    |> Enum.map(fn
      {{r, c}, "O"} -> [{{r, c * 2}, "["}, {{r, c * 2 + 1}, "]"}]
      {{r, c}, "@"} -> [{{r, c * 2}, "@"}, {{r, c * 2 + 1}, "."}]
      {{r, c}, "."} -> [{{r, c * 2}, "."}, {{r, c * 2 + 1}, "."}]
      {{r, c}, "#"} -> [{{r, c * 2}, "#"}, {{r, c * 2 + 1}, "#"}]
    end)
    |> List.flatten()
    |> Map.new()
  end

  def left({r, c}), do: {r, c - 1}
  def right({r, c}), do: {r, c + 1}

  def pair(map, {r, c}) do
    case Map.get(map, {r, c}) do
      "[" -> [{r, c}, right({r, c})]
      "]" -> [left({r, c}), {r, c}]
      _ -> [{r, c}]
    end
  end

  def move_boxes_vert(map, horiz_support, dir, moving_boxes) do
    next_row =
      Enum.map(horiz_support, &next_pos(&1, dir))

    cond do
      Enum.any?(next_row, &(Map.get(map, &1) == "#")) ->
        {:nok, []}

      Enum.all?(next_row, &(Map.get(map, &1) == ".")) ->
        {:ok, moving_boxes}

      true ->
        hs =
          Enum.flat_map(next_row, fn x ->
            case Map.get(map, x) do
              "." -> []
              "[" -> pair(map, x)
              "]" -> pair(map, x)
              _ -> :error
            end
          end)
          |> List.flatten()
          |> Enum.uniq()

        move_boxes_vert(
          map,
          hs,
          dir,
          [hs | moving_boxes] |> List.flatten() |> Enum.uniq()
        )
    end
  end

  def part2(args) do
    {map, seq} =
      args
      |> process_input()

    map2 = transform(map)
    start = Enum.find(map2, fn {_, v} -> v == "@" end) |> elem(0)

    map2
    |> Map.put(start, ".")
    |> move(start, seq)
    |> gps()
  end
end
