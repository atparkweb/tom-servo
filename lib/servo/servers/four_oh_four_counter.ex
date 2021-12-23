defmodule Servo.FourOhFourCounter do
  @process __MODULE__

  def start() do
    IO.puts "Starting 404 counter server..."
    pid = spawn(__MODULE__, :listen, [%{}])
    Process.register(pid, @process)
    pid
  end

  def inc(path) do
    send @process, {self(), :increment, path}
    receive do {:response, count} -> count end
  end

  def get_count(path) do
    send @process, {self(), :count, path}
    receive do {:response, count} -> count end
  end

  def get_counts() do
    send @process, {self(), :all_counts}
    receive do {:response, counts} -> counts end
  end

  def listen(state) do
    receive do
      {pid, :increment, path} ->
        new_state = Map.update(state, path, 1, fn c -> c + 1 end)
        send pid, {:response, Map.get(new_state, path) }
        listen(new_state)
      {pid, :count, path} ->
        send pid, {:response, Map.get(state, path)}
        listen(state)
      {pid, :all_counts} ->
        send pid, {:response, state}
        listen(state)
    end
  end
end
