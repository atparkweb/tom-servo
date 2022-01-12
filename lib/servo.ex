defmodule Servo do
  use Application

  def start(_type, _args) do
    IO.puts "Starting the application..."
    Servo.Supervisor.start_link()
  end
end
