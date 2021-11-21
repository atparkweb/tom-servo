defmodule Servo.Controllers.MessageController do
  alias Servo.MessageServer

  def index(req) do
    messages = MessageServer.recent_messages()
    %{ req | status: 200, res_body: (inspect messages) }
  end
  
  def create(req, %{"name" => name, "message" => message}) do
    status = MessageServer.create_message(name, message)
    %{ req | status: 201, res_body: "Message sent: #{status}" }
  end
end
