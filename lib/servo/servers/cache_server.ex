defmodule Servo.Servers.CacheServer do
  @name :cache_server
  @default_refresh_interval :timer.minutes(60)

  use GenServer

  defmodule State do
    defstruct data: [],
              refresh_interval: :timer.minutes(60)
  end

  def start do
    IO.puts "Starting cache server..."
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def get_api_data do
    GenServer.call @name, :get_api_data
  end

  def set_refresh_interval(t) do
    GenServer.cast @name, {:set_refresh_interval, t}
  end

  @impl true
  def init(_args) do
    initial_data = run_tasks_to_get_data()
    schedule_refresh(@default_refresh_interval)
    {:ok, %{ data: initial_data, refresh_interval: @default_refresh_interval}}
  end

  @impl true
  def handle_call(:get_api_data, _from, state) do
    {:reply, state.data, state}
  end

  @impl true
  def handle_cast({:set_refresh_interval, t}, _from, state) do
    {:noreply, %{ state | refresh_interval: t }}
  end

  @impl true
  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache..."
    new_data = run_tasks_to_get_data()
    schedule_refresh(state.refresh_interval)
    {:noreply, %{ state | data: new_data }}
  end
  def handle_info(unexpected, state) do
    IO.puts "Unexpected message! #{inspect unexpected}"
    {:noreply, state}
  end

  defp schedule_refresh(t) do
    Process.send_after(self(), :refresh, t)
  end

  defp run_tasks_to_get_data do
    IO.puts "Running tasks to bootstrap data..."

    results =
      [:one, :two, :three]
      |> Enum.map(&Task.async(fn -> Api.Client.get_data(&1) end))
      |> Enum.map(&Task.await(&1, :timer.seconds(7)))

    results
  end
end
