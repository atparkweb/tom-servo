defmodule Servo.Controllers.BotController do
  import Servo.View

  alias Servo.Resources.BotStore
  alias Servo.Request

  def index(req) do
    bot_list =
      BotStore.list_bots
      |> Enum.filter(fn(b) -> b.is_active end)

    render(req, "index.eex", bots: bot_list)
  end

  def show(req, %{ "id" => id }) do
    bot = BotStore.get_bot(id)

    render(req, "show.eex", bot: bot)
  end

  def create(req, %{ "name" => name, "color" => color }) do
    # Mock success response. Nothing is created
    %Request{ req | status: 201, res_body: "Created a #{color} bot named #{name}" }
  end

  def delete(req, _params) do
    %Request{ req | status: 403, res_body: "Removing a bot is not allowed" }
  end
end
