defmodule Servo.Parser do
  alias Servo.Request

  def parse(request) do
    # Separate request body from headers
    [head, body] = String.split(request, "\n\n")
    
    # Separate request headers from request method line
    [request_line | _headers] = String.split(head, "\n")

    [method, path, _] = String.split(request_line, " ")
    
    params = parse_params(body)

    %Request{
      method: method,
      path: path,
      params: params
    }
  end
  
  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end
end
