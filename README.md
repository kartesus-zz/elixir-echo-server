# Echo server in Elixir

## Create the project

```
mix new echo --bare  
```

## TCP Server
There is a Erlang module called gen_tcp that we'll use to for communicating
with TCP sockets.

In ```lib/server.ex``` we have the module responsible for that. It starts
a server

```elixir
def start(port) do
  tcp_options = [:binary, {:packet, 0}, {:active, false}]
  {:ok, socket} = :gen_tcp.listen(port, tcp_options)
  listen(socket)
end
```

then loop forever accepting income connections

```elixir
defp listen(socket) do
  {:ok, conn} = :gen_tcp.accept(socket)
  spawn(fn -> recv(conn) end)
  listen(socket)
end
```

when a client connects it spawns a new process and start receiving data
from the new made connection

```elixir
defp recv(conn) do
  case :gen_tcp.recv(conn, 0) do
    {:ok, data} ->
      :gen_tcp.send(conn, data)
      recv(conn)
    {:error, :closed} ->
      :ok
  end
end
```

## Running on the console.
To run this open a console and start the server.

```
$ iex -S mix
iex> Echo.Server.start(6000)
```

The ```-S mix``` options will load your project into the current session.

Connect using telnet or netcat and try it out.

## Automating tasks
Create a ```lib/tasks.ex``` file and a module called ```Mix.Tasks.Start```. The
```run``` function will be called by mix when we invoke the task.

```elixir
def run(_) do
  Echo.Server.start(6000)
end
```

Compile your app and start the server

```
$ mix compile
$ mix start
```

or 
```
$ mix do compile, start
```
