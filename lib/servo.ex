defmodule Servo do
  alias Servo.HttpServer

  def start(port \\ 4000) do
    HttpServer.start(port)
  end
end
