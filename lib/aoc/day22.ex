defmodule Aoc.Day22 do
  import Bitwise

  def mix(a, b) do
    bxor(a, b)
  end

  def prune(a) do
    # rem(a, 2 ** 24)
    # is equivalent to
    band(a, 2 ** 24 - 1)
  end

  def next_secret(secret) do
    a =
      secret
      |> Kernel.*(64)
      |> mix(secret)
      |> prune()

    b =
      a
      |> Kernel./(32)
      |> floor()
      |> mix(a)
      |> prune()

    b
    |> Kernel.*(2048)
    |> mix(b)
    |> prune()
  end

  def cycle(secret, n), do: Enum.reduce(1..n, secret, fn _, acc -> next_secret(acc) end)

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Task.async_stream(fn secret -> cycle(secret, 2000) end,
      ordered: false,
      timeout: :infinity
    )
    |> Stream.map(fn {:ok, x} -> x end)
    |> Enum.sum()
  end

  def cycle2(secret, n) do
    for _i <- 0..(n - 1),
        reduce: {rem(secret, 10), [], secret, %{}} do
      acc ->
        {prev_last_digit, prev_changes, sec, seq_map} = acc
        next_sec = next_secret(sec)
        last_digit = next_sec |> rem(10)

        changes =
          (prev_changes ++ [last_digit - prev_last_digit]) |> Enum.take(-4)

        {
          last_digit,
          changes,
          next_sec,
          Map.update(seq_map, changes, last_digit, &Function.identity/1)
        }
    end
    |> elem(3)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Task.async_stream(fn secret -> cycle2(secret, 2000) end,
      ordered: false,
      timeout: :infinity
    )
    |> Stream.map(fn {:ok, x} -> x end)
    |> Enum.reduce(%{}, fn x, acc -> Map.merge(x, acc, fn _k, v1, v2 -> v1 + v2 end) end)
    |> Enum.max_by(fn {_k, v} -> v end)
    |> elem(1)
  end
end
