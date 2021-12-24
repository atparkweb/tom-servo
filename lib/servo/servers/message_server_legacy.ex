defmodule Servo.Servers.GenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  # for requests that don't expect a response
  def cast(pid, message) do
    send pid, {:cast, message}
  end

  @doc "Server process loop. State should initially be an empty list."
  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
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

defmodule Servo.Servers.MessageServerLegacy do
  @name :message_server_legacy

  alias Servo.Servers.GenericServer

  def start do
    IO.puts "Starting the message server..."
    GenericServer.start(__MODULE__, [], @name)
  end

  def recent_messages do
    GenericServer.call @name, :recent_messages
  end

  def total_messages do
    GenericServer.call @name, :total_messages
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  def create_message(name, message) do
    GenericServer.call @name, {:create_message, name, message} 
  end

  defp save_message(name, _message) do
    # TODO: Send to backing service
    { :ok, "message from #{name} " }
  end

  def handle_call(:total_messages, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end
  def handle_call(:recent_messages, state) do
    {state, state}
  end
  def handle_call({:create_message, name, message}, state) do
    {:ok, id} = save_message(name, message)

    # last 3 messages
    most_recent = Enum.take(state, 2)
    new_state = [ {name, message} | most_recent ]
    {id, new_state}
  end

  def handle_cast(:clear, _state) do
    []
  end
end

