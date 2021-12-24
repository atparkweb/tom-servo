defmodule Servo.Servers.FourOhFourCounter do
  @name :four_oh_four_server

  use GenServer

  # Client interface

  def start() do
    IO.puts "Starting 404 counter server..."
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def inc(path) do
    GenServer.call @name, {:increment, path}
  end

  def get_count(path) do
    GenServer.call @name, {:count, path}
  end

  def get_counts do
    GenServer.call @name, :all_counts
  end

  def reset do
    GenServer.cast @name, :reset
  end

  # GenServer Behaviour

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_call({:count, path}, _from, state) do
    count = Map.get(state, path)
    {:reply, count, state}
  end
  def handle_call(:all_counts, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:increment, path}, _from, state) do
    new_state = Map.update(state, path, 1, fn c -> c + 1 end)
    count = Map.get(new_state, path)
    {:reply, count, new_state}
  end

  @impl true
  def handle_cast(:reset, _state) do
    {:noreply, %{}}
  end

  @impl true
  def handle_info(message, state) do
    IO.puts "Unexpected message! #{inspect message}"
    {:noreply, state}
  end
end
