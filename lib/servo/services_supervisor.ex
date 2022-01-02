defmodule Servo.ServicesSupervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting the services supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Servo.MessageServer,
      {Servo.CacheServer, 60}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
