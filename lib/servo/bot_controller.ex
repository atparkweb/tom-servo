defmodule Servo.BotController do
  alias Servo.Request

  def index(req) do
    %Request{ req | status: 200, res_body: "Cambot, Gypsy, Tom Servo, Croooooow" }
  end
  
  def show(req, %{ "id" => id }) do
    %Request{ req | status: 200, res_body: "Bot #{id}" }
  end
end
