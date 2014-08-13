{set_time, _} = :timer.tc fn ->
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
{list_time, _} = :timer.tc fn ->
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

IO.puts "TreeSet: #{set_time} vs List: #{list_time}"
