defmodule Servo.Servers.CacheServer do
  @name :cache_server

  use GenServer

  defmodule State do
    defstruct data: []
  end

  def start do
    IO.puts "Starting cache server..."
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def get_api_data do
    GenServer.call @name, :get_api_data
  end

  @impl true
  def init(_args) do
    initial_state = run_tasks_to_get_data()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_api_data, _from, state) do
    {:reply, state.data, state}
  end

  defp run_tasks_to_get_data do
    IO.puts "Running tasks to bootstrap data..."

    results =
      [:one, :two, :three]
      |> Enum.map(&Task.async(fn -> Api.Client.get_data(&1) end))
      |> Enum.map(&Task.await(&1, :timer.seconds(7)))

    %{ data: results }
  end
end
