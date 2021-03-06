defmodule Servo.KickStarter do
  @name :http_server

  use GenServer

  def start do
    IO.puts "Starting kickstarter..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link(_arg) do
    IO.puts "Starting kickstarter (supervised)..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
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
    port = Application.get_env(:servo, :port)
    pid = spawn_link(Servo.HttpServer, :start, [port])
    Process.register(pid, @name)
    pid
  end
end
