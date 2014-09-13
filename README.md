Structurez
==========

A playground for data structures

### `Treeset`
An ordered set wrapping `:gb_sets`

### `AgentDict`
A dict backed by an Agent. WARNING: This should make you cringe. It's essentially a mutable Dict. Only use this when you need concurrent access. There are a lot of other terrible ways to use it.

### `TCPClient.stream/1`
`Streamz.Net.TCPClient.stream/1` accepts a keyword list with `:host` and `:port` set. It will connect the the host and port and supports Enumerable and Collectable. This enables a bunch of cool things.

#### Connecting:

```elixir
n = TCPClient.stream([host: "localhost", port: 4444])
```

#### Reading data:

```elixir
n |> Enum.each &IO.inspect(&1)
```

#### Writing data:

```elixir
["Hello", "World"] |> Enum.into(n)
```

#### Echo Client (writes any data it receives back to the server):

```elixir
n |> Enum.into(n)
```

## Up Next
There are tons of possibilities. Here's what is on the current radar.

- `TCPServer/1` - A server version of `TCPClient`
- `UDPClient/1` - A UDP version of `TCPClient`
- `UDPServer/1` - A server version of `UDPClient`
- `WebSockets.stream/1` - Bidirection stream for a websocket connection.

