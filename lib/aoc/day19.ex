defmodule Aoc.Day19 do
  use Memoize

  def process_input(input) do
    [patterns, designs] =
      input
      |> String.split("\n\n", trim: true)

    {patterns |> String.split(", ", trim: true), designs |> String.split("\n", trim: true)}
  end

  defmemo(search_combinations(_patterns, ""), do: 1)

  defmemo search_combinations(patterns, design) do
    for p <- patterns, reduce: 0 do
      acc ->

        case design do
          <<^p::binary, rest::binary>> ->
            acc + search_combinations(patterns, rest)

          _ ->
          acc
        end
    end
  end

  def part1(args) do
    {patterns, designs} =
      args
      |> process_input()

    designs
    |> Task.async_stream(fn design -> search_combinations(patterns, design) end,
      ordered: false,
      timeout: :infinity
    )
    |> Stream.filter(fn {:ok, x} -> x > 0 end)
    |> Enum.count()
  end


  def part2(args) do
    {patterns, designs} =
      args
      |> process_input()

      designs
      |> Task.async_stream(fn design -> search_combinations(patterns, design) end,
        ordered: false,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, x} -> x  end)
      |> Enum.sum()
  end
end
