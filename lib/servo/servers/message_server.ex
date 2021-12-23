defmodule Servo.MessageServer do
  @process __MODULE__

  def start do
    IO.puts "Starting message server..."
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @process)
    pid
  end

  def recent_messages do
    call @process, :recent_messages
  end

  def total_messages do
    call @process, :total_messages
  end

  def create_message(name, message) do
    call @process, {:create_message, name, message} 
  end

  def call(pid, message) do
    send pid, {self(), message}
    receive do {:response, response} -> response end
  end

  defp save_message(name, _message) do
    # TODO: Send to backing service
    { :ok, "message from #{name} " }
  end

  @doc "Server process loop. State should initially be an empty list."
  def listen_loop(state) do
    receive do
      {sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
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
end

