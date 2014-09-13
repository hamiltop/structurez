defmodule TCPSocket do
  @moduledoc false
  defstruct socket: nil
end

defimpl Enumerable, for: TCPSocket do
  def reduce(stream, acc, reducer) do
    Stream.unfold(
      stream,
      fn (stream) ->
        case next(stream) do
          {:ok, value} -> {value, stream}
          _ -> nil
        end
      end
    ).(acc, reducer)
  end
  
  #@spec next(%TCPSocket{}) :: binary
  defp next(stream) do
    stream.socket |> :gen_tcp.recv(0)
  end

  def member?(_,_), do: {:error, __MODULE__}
  def count(_), do: {:error, __MODULE__}
end

defimpl Collectable, for: TCPSocket do
  def into(stream) do
    {:ok, fn
        :ok, {:cont, x} -> write(stream, x)
        :ok, _ -> stream
    end}
  end

  @spec write(%TCPSocket{}, binary) :: :ok 
  defp write(stream, data) do
    :ok = stream.socket |> :gen_tcp.send(data)
  end

  def empty(stream), do: stream
end
