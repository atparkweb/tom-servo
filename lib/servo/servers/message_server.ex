defmodule Servo.MessageServer do
  @process __MODULE__

  def start do
    IO.puts "Starting message server..."
    pid = spawn(__MODULE__, :listen, [[]])
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
  def listen(state) do
    receive do
      {pid, {:create_message, name, message}} ->
        {:ok, id} = save_message(name, message)

        # only track last 3 messages
        new_state = [ {name, message} | Enum.take(state, 2) ]
        send pid, {:response, id}
        listen(new_state)
      {pid, :recent_messages} ->
        send pid, {:response, state}
        listen(state)
      {pid, :total_messages} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send pid, {:response, total}
        listen(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen(state)
    end
  end
end

