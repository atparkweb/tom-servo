defmodule Servo.Handler do
  require Logger

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
  
  def trace(%{ status: 404, path: path } = req) do
    Logger.warn("Warning: undefined path: #{path}")
    req
  end
  
  def trace(req), do: req
  
  def rewrite_path(%{ path: path } = req) do
    regex = ~r{\/(?<name>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(req, captures)
  end
  
  def rewrite_path(req), do: req
  
  def rewrite_path_captures(req, %{ "name" => name, "id" => id }) do
    %{ req | path: "/#{name}/#{id}" }
  end
  def rewrite_path_captures(req, nil), do: req
  
  defp status_icon(200), do: "✅ "
  defp status_icon(201), do: "✅ "
  defp status_icon(_), do: "⛔ "

  def emojify(%{ status: status } = req) do
    %{ req | resp_body: "#{status_icon(status)}\n" <> req.resp_body }
  end
  
  def log(req) do
    Logger.info(req)
    req
  end
  
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
  
  def route(%{ method: "DELETE" } = req) do
    %{ req | status: 403, resp_body: "Delete operations are not authorized"}
  end

  def route(%{ method: method, path: path } = req) do
    %{ req | status: 404, resp_body: "Cannot #{method} route #{path}" }
  end
  
  def format_response(%{ status: status, resp_body: resp_body }) do
    """
    HTTP/1.1 #{status} #{status_desc(status)}
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)} 

    #{resp_body}
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
GET /bot/42 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

""", rewrite: """
GET /bot?id=43 HTTP/1.1
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

"""
}

responses =
  Map.values(requests)
  |> Enum.map(fn r -> Servo.Handler.handle(r) end)
  |> Enum.join("\n============\n")

IO.puts "\n==========\n" <> responses
