defmodule Servo.Handler do
  
  @moduledoc "Handles HTTP requests."

  # Attributes
  @pages_path Path.expand("../../pages", __DIR__)
  
  import Servo.Utils, only: [ emojify: 1, log: 1, rewrite_path: 1, trace: 1 ]
  import Servo.Parser, only: [ parse: 1 ]
  import Servo.FileHandler, only: [ handle_file: 2 ]
  
  alias Servo.Request

  @doc "Transfroms request into a response."
  def handle(req) do
    req
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> emojify
    |> trace
    |> format_response
  end
  
  # Routes
  def route(%Request{ method: "GET", path: "/bots" } = req) do
    bots = ["Cambot", "Gypsy", "Tom Servo", "Croooooow"]
    %Request{ req | status: 200, res_body: Enum.join(bots, "\n") }
  end

  def route(%Request{ method: "GET", path: "/bots" <> id } = req) do
    %Request{ req | status: 200, res_body: "Bot #{id}" }
  end
  
  def route(%Request{ method: "GET", path: "/sirs" } = req) do
    sirs = ["Dr. Clayton Brown", "TV's Frank"]
    %Request{ req | status: 200, res_body: Enum.join(sirs, "\n")}
  end

  def route(%Request{ method: "GET", path: "/pages/" <> page } = req) do
    @pages_path
    |> Path.join("#{page}.html")
    |> File.read
    |> handle_file(req)
  end

  def route(%Request{ method: "DELETE" } = req) do
    %Request{ req | status: 403, res_body: "Delete operations are not authorized"}
  end

  def route(%Request{ method: method, path: path } = req) do
    %Request{ req | status: 404, res_body: "Cannot #{method} route #{path}" }
  end
  
  def format_response(%Request{} = req) do
    """
    HTTP/1.1 #{Request.full_status(req)}
    Content-Type: text/html
    Content-Length: #{String.length(req.res_body)} 

    #{req.res_body}
    """
  end
  
end

requests = %{
bots: """
GET /bots HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", bot: """
GET /bots/42 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", new_bot: """
GET /pages/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", rewrite: """
GET /bots?id=43 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", sirs: """
GET /sirs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", delete: """
DELETE /sirs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", not_found: """
GET /films HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", page_req: """
GET /pages/home HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", form_req: """
GET /bots/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

}

responses =
  Map.values(requests)
  |> Enum.map(fn r -> Servo.Handler.handle(r) end)
  |> Enum.join("\n============\n")

IO.puts "\n==========\n" <> responses
