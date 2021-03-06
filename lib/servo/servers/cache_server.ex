defmodule Servo.CacheServer do
  @name :cache_server

  use GenServer, restart: :permanent

  defmodule State do
    defstruct data: [],
              refresh_interval: :timer.minutes(60)
  end

  def start do
    IO.puts "Starting cache server..."
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def start_link(interval) do
    refresh = :timer.minutes(interval)
    IO.puts "Starting cache server with min refresh #{interval} minutes..."
    GenServer.start_link(__MODULE__, %State{ refresh_interval: refresh}, name: @name)
  end

  def get_api_data do
    GenServer.call @name, :get_api_data
  end

  def set_refresh_interval(time_in_ms) do
    GenServer.cast @name, {:set_refresh_interval, time_in_ms}
  end

  @impl true
  def init(state) do
    data = run_tasks_to_get_data()
    initial_state = %{ state | data: data }
    schedule_refresh(state.refresh_interval)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_api_data, _from, state) do
    {:reply, state.data, state}
  end

  @impl true
  def handle_cast({:set_refresh_interval, time_in_ms}, state) do
    new_state = %{ state | refresh_interval: time_in_ms }
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache..."
    data = run_tasks_to_get_data()
    new_state = %{ state | data: data }
    schedule_refresh(state.refresh_interval)
    {:noreply, new_state}
  end
  def handle_info(unexpected, state) do
    IO.puts "Unexpected message! #{inspect unexpected}"
    {:noreply, state}
  end

  defp schedule_refresh(time_in_ms) do
    Process.send_after(self(), :refresh, time_in_ms)
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
