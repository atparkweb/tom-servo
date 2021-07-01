defmodule Servo.Handler do
  def handle(req) do
    req
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> trace
    |> format_response
  end
  
  def trace(%{ status: 404, path: path } = req) do
    IO.puts "Warning: undefined path: #{path}"
    req
  end
  
  def trace(req), do: req
  
  def rewrite_path(%{ path: "/robots" } = req) do
    %{ req | path: "/bots" }
  end
  
  def rewrite_path(req), do: req
  
  def log(req), do: IO.inspect req
  
  def parse(req) do
    [method, path, _] =
      req
        |> String.split("\n")
        |> List.first
        |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil }
  end
  
  # Routes
  def route(%{ method: "GET", path: "/bots" } = req) do
    bots = ["Cambot", "Gypsy", "Tom Servo", "Croooooow"]
    %{ req | status: 200, resp_body: Enum.join(bots, "\n") }
  end

  def route(%{ method: "GET", path: "/bot/" <> id } = req) do
    %{ req | status: 200, resp_body: "Bot #{id}" }
  end

  def route(%{ method: "GET", path: "/sirs" } = req) do
    sirs = ["Dr. Clayton Brown", "TV's Frank"]
    %{ req | status: 200, resp_body: Enum.join(sirs, "\n")}
  end

  def route(%{ method: method, path: path } = req) do
    %{ req | status: 404, resp_body: "Cannot #{method} route #{path}" }
  end
  
  def format_response(req) do
    """
    HTTP/1.1 #{req.status} #{status_desc(req.status)}
    Content-Type: text/html
    Content-Length: #{String.length(req.resp_body)} 

    #{req.resp_body}
    """
  end
  
  defp status_desc(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

requests = %{
bots: """
GET /bots HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", bot: """
GET /bot/66 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", sirs: """
GET /sirs HTTP/1.1
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
