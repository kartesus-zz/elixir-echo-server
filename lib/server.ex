defmodule Echo.Server do
  def start(port) do
    tcp_options = 
      [:list, {:packet, 0}, {:active, false}, {:reuseaddr, true}]

    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    listen(socket)
  end

  defp listen(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> server(conn) end)
    listen(socket)
  end

  defp server(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        :gen_tcp.send(conn, data)
        server(conn)
      {:error, :closed} ->
        :ok
    end
  end
end
