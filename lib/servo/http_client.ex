defmodule Servo.HttpClient do
  @moduledoc "This is a mock client for development and testing"

  @doc """
  Starts a client on the given `port` of localhost. (Ports 0-1023 are reserved for host OS)
  """
  def send_request(request) do
    # use `localhost` for client and server on same machine
    some_host_in_net = 'localhost'
    {:ok, socket} =
      :gen_tcp.connect(some_host_in_net, 4000, [:binary, packet: :raw, active: false])

    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    
    response
  end
end
