defmodule Servo.Handler do
  
  @moduledoc "Handles HTTP requests."

  import Servo.Routes, only: [ route: 1 ]
  import Servo.Utils, only: [ emojify: 1, log: 1, rewrite_path: 1, trace: 1 ]
  import Servo.Parser, only: [ parse: 1 ]
  
  alias Servo.Request

  @doc "Transfroms an HTTP request string into a response."
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

""", post_req: """
POST /bots HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=R2D2&type=Astro
"""
}

response = Servo.Handler.handle(requests.form_req)
IO.puts response
