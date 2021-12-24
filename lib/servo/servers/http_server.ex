defmodule Servo.Servers.HttpServer do
  @moduledoc "An HTTP server that uses Erlang's GenTCP library"

  @doc """
  Starts the server on the given `port` of localhost. (Ports 0-1023 are reserved for OS)
  """
  def start(port) when is_integer(port) and port > 1023 do
    options = [:binary, backlog: 10, packet: :raw, active: false, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, options)

    IO.puts "\n Listening for connection requests on port #{port}...\n"

    accept_loop(listen_socket)
  end

  defp accept_loop(listen_socket) do
    IO.puts " Waiting to accept a client connection...\n"

    # Suspends (blocks) and waits for a client connection.
    # When a connection is accepted, `client_socket` is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts " Connection accepted!\n"

    # Receives the request and sends a response over the client socket.
    pid = spawn(fn -> serve(client_socket) end)

    # make this the controlling process, so the socket closes properly
    :ok = :gen_tcp.controlling_process(client_socket, pid)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  @doc """
  Receives the request on the `client_socket` and sends a response back over the same socket.
  """
  def serve(client_socket) do
    IO.puts "#{inspect self()}: Working..."
    client_socket
    |> read_request
    |> Servo.Handler.handle
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0) # all available bytes
    request
  end

  @doc """
  Sends `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(client_socket)
  end
end
