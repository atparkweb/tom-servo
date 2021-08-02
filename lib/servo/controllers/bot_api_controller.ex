defmodule Servo.Controllers.BotApiController do
  def index(req) do
    json =
      Servo.Resources.BotStore.list_bots()
      |> Poison.encode!
    
    new_headers = Map.put(req.res_headers, "Content-Type", "application/json")
    
    %{ req | status: 200, res_headers: new_headers, res_body: json }
  end
end
