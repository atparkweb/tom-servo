defmodule Servo.KickStarter do
  use GenServer

  def start do
    IO.puts "Starting kickstarter..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  @impl true
  def handle_info(message, _state) do
    IO.puts "CRASH: #{inspect message}"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts "Starting the HTTP server..."
    server_pid = spawn_link(Servo.Servers.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
  end
end
