defmodule Servo.GenServerTwo do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servo.FourOhFourCounter do
  @name :four_oh_four_server

  alias Servo.GenServerTwo

  def start() do
    IO.puts "Starting 404 counter server..."
    GenServerTwo.start(__MODULE__, %{}, @name)
  end

  def handle_call({:count, path}, state) do
    count = Map.get(state, path)
    {count, state}
  end
  def handle_call(:all_counts, state) do
    {state, state}
  end

  def handle_cast({:increment, path}, state) do
    new_state = Map.update(state, path, 1, fn c -> c + 1 end)
    new_state
  end

  def inc(path) do
    GenServerTwo.cast @name, {:increment, path}
  end

  def get_count(path) do
    GenServerTwo.call @name, {:count, path}
  end

  def get_counts() do
    GenServerTwo.call @name, :all_counts
  end
end
