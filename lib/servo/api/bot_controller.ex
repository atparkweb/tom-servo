defmodule Servo.Api.BotController do
  def index(req) do
    json =
      Servo.BotStore.list_bots()
      |> Poison.encode!
    
    %{ req | status: 200, res_content_type: "application/json", res_body: json }
  end
end
