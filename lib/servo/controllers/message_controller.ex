defmodule Servo.Controllers.MessageController do
  import Servo.View
  alias Servo.MessageServer

  def index(req) do
    messages = MessageServer.recent_messages()
    render(req, "recent_messages.eex", messages: messages)
  end

  def new(req) do
    render(req, "new_message.eex")
  end

  def create(req, %{"name" => name, "message" => message}) do
    status = MessageServer.create_message(name, message)
    %{ req | status: 201, res_body: "Message sent: #{status}" }
  end
end
