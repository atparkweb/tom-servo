# Erlang example:
# client() ->
#     SomeHostInNet = "localhost", % to make it runnable on one machine
#     {ok, Sock} = gen_tcp:connect(SomeHostInNet, 5678,
#                                  [binary, {packet, 0}]),
#     ok = gen_tcp:send(Sock, "Some Data"),
#     ok = gen_tcp:close(Sock).

defmodule Servo.HttpClient do
  @doc """
  Starts a client on the given `port` of localhost. (Ports 0-1023 are reserved for host OS)
  """
  def send_request(request) do
    some_host_in_net = 'localhost' # to make it runnable on one machine
    {:ok, socket} =
      :gen_tcp.connect(some_host_in_net, 4000, [:binary, packet: :raw, active: false])

    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    
    response
  end
  
  @doc """
  Returns a mock request for testing.
  """
  def get_request do
    """
    GET /bots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
  end
end
