defmodule Servo.Routes do
  @moduledoc """
  REST Routes. Delegate action to controllers
  """
  
  @pages_path Path.expand("../../pages", __DIR__)

  import Servo.FileHandler, only: [ handle_file: 2, markdown_to_html: 1 ]

  alias Servo.ApiClient
  alias Servo.Controllers.BotController
  alias Servo.Controllers.BotApiController
  alias Servo.Request
  
  # simulate an API request
  def route(%Request{ method: "GET", path: "/api-data" } = req) do
    results =
      [:one, :two, :three]
      |> Enum.map(&Task.async(fn -> ApiClient.get_data(&1) end))
      |> Enum.map(&Task.await/1)
    
    {:ok, res} = Poison.encode(results)
    
    %{ req | status: 200, res_body: res}
  end
  
  def route(%Request{ method: "GET", path: "/kaboom" } = _req) do
    # when something goes wrong
    raise "Kaboom!"
  end

  def route(%Request{ method: "GET", path: "/sleep/" <> time } = req) do
    time |> String.to_integer |> :timer.sleep

    %Request{ req | status: 200, res_body: "Reboot!"}
  end

  def route(%Request{ method: "GET", path: "/bot_crew" } = req) do
    %Request{ req | status: 200, res_body: "Cambot, Gypsy, Tom Servo, Crow"}
  end

  def route(%Request{ method: "GET", path: "/bots" } = req) do
    BotController.index(req)
  end

  def route(%Request{ method: "GET", path: "/bots/" <> id } = req) do
    params = Map.put(req.params, "id", id)
    BotController.show(req, params)
  end
  
  def route(%Request{ method: "GET", path: "/pages/" <> page } = req) do
    @pages_path
    |> Path.join("#{page}.md")
    |> File.read
    |> handle_file(req)
    |> markdown_to_html
  end
  
  def route(%Request{ method: "GET", path: "/" } = req) do
    route(%Request{ req | path: "/pages/home" })
  end
  
  def route(%Request{ method: "POST", path: "/bots" } = req) do
    BotController.create(req, req.params)
  end

  def route(%Request{ method: "DELETE", path: "/bots/" <> id } = req) do
    params = Map.put(req.params, "id", id)
    BotController.delete(req, params)
  end

  def route(%Request{ method: "GET", path: "/api/bots" } = req) do
    BotApiController.index(req)
  end

  def route(%Request{ method: "POST", path: "/api/bots" } = req) do
    BotApiController.create(req, req.params)
  end

  def route(%Request{ method: method, path: path } = req) do
    %Request{ req | status: 404, res_body: "Cannot #{method} route #{path}" }
  end
end
