defmodule TreeSetTest do
  use ExUnit.Case

  test "prime number sieve" do
    IO.inspect :timer.tc fn ->
      2..1000000 |> Enum.reduce TreeSet.new, fn (el, set) ->
        has_factors = set
          |> Stream.take_while(&(&1 <= :math.sqrt(el)))
          |> Enum.any?( &(rem(el, &1) == 0 ) )
        case has_factors do
          true -> set
          false -> Set.put(set, el)
        end
      end
    end
    IO.inspect :timer.tc fn ->
      2..1000000 |> Enum.reduce [], fn (el, set) ->
        has_factors = set
          |> Stream.take_while(&(&1 <= :math.sqrt(el)))
          |> Enum.any?( &(rem(el, &1) == 0 ) )
        case has_factors do
          true -> set
          false -> set ++ [el]
        end
      end
    end
  end
end
