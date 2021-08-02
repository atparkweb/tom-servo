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
    HTTP/1.1 #{Request.full_status(req)}\r
    Content-Type: #{req.res_content_type}\r
    Content-Length: #{String.length(req.res_body)}\r
    \r
    #{req.res_body}
    """
  end
  
end

