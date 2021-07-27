defmodule Servo.BotController do
  alias Servo.Bot
  alias Servo.BotStore
  alias Servo.Request
  
  @templates_path Path.expand("../../templates", __DIR__)
  
  defp render(req, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template) 
      |> EEx.eval_file(bindings)

    %Request{ req | status: 200, res_body: content }
  end

  def index(req) do
    bot_list =
      BotStore.list_bots
      |> Enum.filter(fn(b) -> b.is_active end)
      |> Enum.sort(&Bot.order_by_name_asc/2) # sort alphabetically by name

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
