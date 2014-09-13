defmodule AgentDict do
  defstruct agent: nil

  use Dict

  def start_link(options \\ []) do
    {:ok, agent} = Agent.start_link(__MODULE__, :new, [], options)
    {:ok, %__MODULE__{agent: agent}}
  end

  def new do
    %{}
  end

  def delete(source, key) do
    Agent.update source.agent, Dict, :delete, [key]
    source
  end

  def fetch(source, key) do
    Agent.get source.agent, Dict, :fetch, [key]
  end

  def put(source, key, value) do
    Agent.update source.agent, Dict, :put, [key, value]
    source
  end

  def size(source) do
    Agent.get source.agent, Dict, :size, []
  end

  def get(source, key) do
    Agent.get source.agent, Access.Map, :get, [key]
  end

  def get_and_update(source, key, fun) do
    Agent.get_and_update source.agent, Access.Map, :get_and_update, [key, fun]
  end

  def reduce(source, acc, fun) do
    map = Agent.get source.agent, &(&1)
    Enumerable.reduce(map, acc, fun)
  end

  def member?(source, key) do
    Agent.get source.agent, Enumerable.Map, :member?, [key]
  end

  def count(source) do
    Agent.get source.agent, Enumerable.Map, :count, []
  end

  def empty(source) do
    Agent.update source.agent, Collectable.Map, :empty, []
    source
  end

  def into(original) do
    {original, fn
      source, {:cont, {k, v}} -> put(source, k, v)
      source, :done -> source 
      _, :halt -> :ok
    end}
  end
end

defimpl Access, for: AgentDict do
  defdelegate get(source, key), to: AgentDict
  defdelegate get_and_update(source, key, fun), to: AgentDict
end

defimpl Enumerable, for: AgentDict do
  defdelegate reduce(source, key, fun), to: AgentDict
  defdelegate member?(source, key), to: AgentDict
  defdelegate count(source), to: AgentDict
end

defimpl Collectable, for: AgentDict do
  defdelegate into(original), to: AgentDict
end
