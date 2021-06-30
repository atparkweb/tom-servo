defmodule Servo.Handler do
  def handle(req) do
    req
    |> parse
    |> log
    |> route
    |> format_response
  end
  
  def log(req), do: IO.inspect req
  
  def parse(req) do
    [method, path, _] =
      req
        |> String.split("\n")
        |> List.first
        |> String.split(" ")

    %{ method: method, path: path, resp_body: "" }
  end
  
  def route(%{method: "GET", path: "/bots"} = req) do
    %{ req | resp_body: "Cambot, Gypsy, Tom Servo, Crooooooow" }
  end

  def route(%{method: "GET", path: "/sirs"} = req) do
    %{ req | resp_body: "Clayton Brown, TV's Frank" }
  end
  
  def format_response(req) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(req.resp_body)} 

    #{req.resp_body}
    """
  end
end

request = """
GET /bots HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servo.Handler.handle(request)

IO.puts response
