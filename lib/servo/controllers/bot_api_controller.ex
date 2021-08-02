defmodule Servo.Controllers.BotApiController do

  import Servo.Utils, only: [ put_res_content_type: 2 ]

  def index(req) do
    json =
      Servo.Resources.BotStore.list_bots()
      |> Poison.encode!
    
    req = put_res_content_type(req, "application/json")
    
    %{ req | status: 200, res_body: json }
  end
end
