defmodule AgentDictTest do
  use ExUnit.Case

  test "start_link" do
    assert {:ok, test} = AgentDict.start_link()
    assert test[:hi] == nil
    Dict.put(test, :hi, :bye)
    assert test[:hi] == :bye
    Dict.put(test, :hello, :goodbye)
    assert Enum.take(test, 3) == [hello: :goodbye, hi: :bye]
  end

  test "into" do
    start = %{a: 1, b: 2}
    {:ok, a} = AgentDict.start_link()
    Enum.into(start, a)
    assert a[:a] == 1
    assert a[:b] == 2
    assert Enum.into(a, %{}) == start
    assert a[:b] == 2
    Enum.map(a, fn ({k,v}) -> {k, v * 2} end) |> Enum.into(a)
    assert a[:b] == 4
  end
end
