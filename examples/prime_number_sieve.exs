defmodule Primes do
  def fill_with_primes(collection, limit) do
    {time, _} = :timer.tc fn ->
      2..limit |> Enum.reduce collection, fn (el, set) ->
        has_factors = set
          |> Stream.take_while(&(&1 <= :math.sqrt(el)))
          |> Enum.any?( &(rem(el, &1) == 0 ) )
        case has_factors do
          true -> set
          false -> Enum.into([el],set)
        end
      end
    end
    IO.puts "#{inspect(collection)}: #{time}"
  end
end

limit = 10_000_000

Primes.fill_with_primes(TreeSet.new, limit)
Primes.fill_with_primes([], limit)
