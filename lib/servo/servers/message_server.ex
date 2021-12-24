defmodule Servo.MessageServer do
  @name :message_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, messages: []
  end


  # Client interface

  def start do
    IO.puts "Starting the message server..."
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def recent_messages do
    GenServer.call @name, :recent_messages
  end

  def total_messages do
    GenServer.call @name, :total_messages
  end

  def clear do
    GenServer.cast @name, :clear
  end

  def create_message(name, message) do
    GenServer.call @name, {:create_message, name, message} 
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end


  # Server callbacks (GenServer behaviour implementations)

  # init args come from initial state from `start` call
  def init(state) do
    # setting initial state from backing service data
    messages = fetch_recent_from_service()

    new_state = %{ state | messages: messages }
    {:ok, new_state}
  end

  def handle_call(:total_messages, _from, state) do
    total = Enum.count(state.messages)
    {:reply, total, state}
  end
  def handle_call(:recent_messages, _from, state) do
    {:reply, state.messages, state}
  end
  def handle_call({:create_message, name, message}, _from, state) do
    {:ok, id} = save_message(name, message)

    # last 3 messages
    most_recent = Enum.take(state.messages, state.cache_size - 1)
    cached_messages = [ {name, message} | most_recent ]
    new_state = %{ state | messages: cached_messages }
    {:reply, id, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{ state | messages: [] }}
  end
  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{ state | cache_size: size }
    {:noreply, new_state}
  end

  def handle_info(message, state) do
    IO.puts "Unexpected message! #{inspect message}"
    {:noreply, state}
  end

  # Mock backing service functions

  defp save_message(name, _message) do
    # TODO: Send to backing service
    { :ok, "message from #{name} " }
  end

  defp fetch_recent_from_service do
    # Code to fetch data from backing service goes here

    # Example return value
    [ { "axel", "radical" }, { "blaze", "awesome" }, { "adam", "cool" }]
  end

end

# alias Servo.MessageServer

# {:ok, pid} = MessageServer.start()

# send pid, {:alert, "Time's up"}

# MessageServer.set_cache_size(4)

# IO.inspect MessageServer.create_message("Player 2", "Hello")
# # IO.inspect MessageServer.create_message("Player 2", "Hi")
# # IO.inspect MessageServer.create_message("Player 1", "What's up?")
# # IO.inspect MessageServer.create_message("Player 3", "Hola")

# IO.inspect MessageServer.recent_messages()

# IO.inspect MessageServer.total_messages()
