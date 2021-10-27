defmodule Servo.Handler do
  
  @moduledoc "Handles HTTP requests."

  import Servo.Routes, only: [ route: 1 ]
  import Servo.Utils, only: [ log: 1, put_content_length: 1, rewrite_path: 1, trace: 1 ]
  import Servo.Parser, only: [ parse: 1 ]
  
  alias Servo.Request

  @doc "Transforms an HTTP request string into a response."
  def handle(req) do
    req
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> trace
    |> put_content_length
    |> format_response
  end
  
  defp format_response_headers(req) do
    for {key, val} <- req.res_headers do
      "#{key}: #{val}\r"
    end |> Enum.sort |> Enum.reverse |> Enum.join("\n")
  end
  
  def format_response(%Request{} = req) do
    """
    HTTP/1.1 #{Request.full_status(req)}\r
    #{format_response_headers(req)}
    \r
    #{req.res_body}
    """
  end
  
end

