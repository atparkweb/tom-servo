defmodule Servo.Routes do
  @moduledoc """
  REST Routes. Delegate action to Controller
  
  ## Routes:

  ### GET /bots
  Get a list of all bots

  ### GET /bots/:id
  Get a single bot by :id
  
  ### GET /humans
  Get a list of all humans

  ### GET /pages/:name
  Get an HTML page by name

  ### POST /bots
  Create a new bot by sending parameters

  Parameter example: name=R2D2&type=Astro

  DELETE requests are denied
  """

  # Attributes
  @pages_path Path.expand("../../pages", __DIR__)

  import Servo.FileHandler, only: [ handle_file: 2 ]

  alias Servo.BotController
  alias Servo.Request

  def route(%Request{ method: "GET", path: "/bots" } = req) do
    BotController.index(req)
  end

  def route(%Request{ method: "GET", path: "/bots/" <> id } = req) do
    params = Map.put(req.params, "id", id)
    BotController.show(req, params)
  end
  
  def route(%Request{ method: "GET", path: "/humans" } = req) do
    sirs = ["Joel", "Mike", "Dr. Clayton Brown", "TV's Frank"]
    %Request{ req | status: 200, res_body: Enum.join(sirs, "\n")}
  end

  def route(%Request{ method: "GET", path: "/pages/" <> page } = req) do
    @pages_path
    |> Path.join("#{page}.html")
    |> File.read
    |> handle_file(req)
  end
  
  def route(%Request{ method: "POST", path: "/bots" } = req) do
    BotController.create(req, req.params)
  end

  def route(%Request{ method: "DELETE", path: "/bots/" <> id } = req) do
    params = Map.put(req.params, "id", id)
    BotController.delete(req, params)
  end

  def route(%Request{ method: "DELETE" } = req) do
    %Request{ req | status: 403, res_body: "Delete operations are not authorized"}
  end

  def route(%Request{ method: method, path: path } = req) do
    %Request{ req | status: 404, res_body: "Cannot #{method} route #{path}" }
  end
end
