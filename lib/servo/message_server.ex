defmodule Servo.MessageServer do
  @process :message_server

  def start do
    IO.puts "Starting message server..."
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, :message_server)
    pid
  end

  @doc "Server process loop. State should initially be an empty list."
  def listen_loop(state) do
    receive do
      {pid, :create_message, name, message} ->
        {:ok, id} = save_message(name, message)
        
	# only track last 3 messages
        new_state = [ {name, message} | Enum.take(state, 2) ]

	send pid, {:response, id}
        listen_loop(new_state)
      {pid, :recent_messages} ->
        send pid, {:response, state}
        listen_loop(state)
    end
  end

  def recent_messages do
    send @process, {self(), :recent_messages}
    receive do {:response, messages} -> messages end
  end
  
  def create_message(name, message) do
    send @process, {self(), :create_message, name, message} 
    receive do {:response, status} -> status end
  end
  
  defp save_message(name, _message) do
    # TODO: Send to backing service
    { :ok, "message from #{name} " }
  end
end

# alias Servo.MessageServer

# MessageServer.start()
# IO.inspect MessageServer.create_message("andy", "hello!")
# IO.inspect MessageServer.create_message("jessica", "hi Andy!")
# IO.inspect MessageServer.create_message("andy", "remember me?")
# IO.inspect MessageServer.create_message("jessica", "of course! how are you?")
# IO.inspect MessageServer.create_message("andy", "great! you?")

# messages = MessageServer.recent_messages()
# IO.inspect messages
