defmodule Servo.KickStarter do
  @port 4000

  use GenServer

  def start do
    IO.puts "Starting kickstarter..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  @impl true
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  @impl true
  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttpServer exited: (#{inspect reason})"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts "Starting the HTTP server..."
    spawn_link(Servo.Servers.HttpServer, :start, [@port])
  end
end