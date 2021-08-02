defmodule Servo.Handler do
  
  @moduledoc "Handles HTTP requests."

  import Servo.Routes, only: [ route: 1 ]
  import Servo.Utils, only: [ emojify: 1, log: 1, put_content_length: 1, rewrite_path: 1, trace: 1 ]
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
    |> put_content_length
    |> format_response
  end
  
  
  def format_response(%Request{} = req) do
    """
    HTTP/1.1 #{Request.full_status(req)}\r
    Content-Type: #{req.res_headers["Content-Type"]}\r
    Content-Length: #{req.res_headers["Content-Length"]}\r
    \r
    #{req.res_body}
    """
  end
  
end

