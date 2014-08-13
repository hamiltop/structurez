defmodule TreeSet do
  defstruct set: nil
  @behaviour Set

  @implementation :gb_sets

  def delete(set, el) do
    %{set | :set => @implementation.del_element(el, set.set)}
  end

  def difference(set1, set2) do
    %{set1 | :set => @implementation.difference(set1.set, set2.set)}
  end

  def disjoint?(set1, set2) do
    @implementation.is_disjoint(set1.set, set2.set)
  end

  def equal?(set1, set2) do
    (size(set1) == size(set2)) && subset?(set1, set2)
  end

  def intersection(set1, set2) do
    %{set1 | :set => @implementation.intersection(set1.set, set2.set)}
  end

  def member?(set, el) do
    @implementation.is_element(el, set.set)
  end

  def new do
    %__MODULE__{set: @implementation.new}
  end

  def put(set, el) do
    %{set | :set => @implementation.add_element(el, set.set)}
  end

  def size(set) do
    @implementation.size(set.set)
  end

  def subset?(set1, set2) do
    @implementation.is_subset(set1.set, set2.set)
  end

  def to_list(set) do
    @implementation.to_list(set.set)
  end

  def union(set1, set2) do
    %{set1 | :set => @implementation.union(set1.set, set2.set)}
  end

  if @implementation == :gb_sets do
    def reduce(set, acc, reducer) do
      (Stream.unfold @implementation.iterator(set.set), fn (iterator) ->
        case @implementation.next(iterator) do
          {el, iterator} -> {el, iterator}
          :none -> nil
        end
      end).(acc, reducer)
    end
  else
    def reduce(set, acc, reducer) do
      Enumerable.List.reduce(Set.to_list(set), acc, reducer)
    end
  end 
end

defimpl Enumerable, for: TreeSet do
  def reduce(set, acc, fun), do: TreeSet.reduce(set, acc, fun)
  def member?(set, v),       do: {:ok, TreeSet.member?(set, v)}
  def count(set),            do: {:ok, TreeSet.size(set)}
end

defimpl Inspect, for: TreeSet do
  import Inspect.Algebra

  def inspect(set, opts) do
    concat ["#TreeSet<", Inspect.List.inspect(TreeSet.to_list(set), opts), ">"]
  end
end

defimpl Collectable, for: TreeSet do
  def empty(_dict) do
    TreeSet.new
  end

  def into(original) do
    {original, fn
      set, {:cont, x} -> TreeSet.put(set, x)
      set, :done -> set
      _, :halt -> :ok
    end}
  end
end
