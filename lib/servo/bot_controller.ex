defmodule Servo.BotController do
  alias Servo.Bot
  alias Servo.BotStore
  alias Servo.Request
  
  defp bot_item(bot) do
    "<li>#{bot.name} - #{bot.color}</li>"
  end

  def index(req) do
    items =
      BotStore.list_bots
      |> Enum.filter(fn(b) -> b.is_active end)
      |> Enum.sort(&Bot.order_by_name_asc/2) # sort alphabetically by name
      |> Enum.map(&bot_item/1)
      |> Enum.join("\n")
    
    %Request{ req | status: 200, res_body: "<ul>\n#{items}\n</ul>" }
  end
  
  def show(req, %{ "id" => id }) do
    bot = BotStore.get_bot(id)
    %Request{ req | status: 200, res_body: "Bot #{bot.name} (#{bot.color})" }
  end
  
  def create(req, %{ "name" => name, "type" => type }) do
    %Request{ req | status: 201, res_body: "Created a #{type} bot named #{name}" }
  end
end
