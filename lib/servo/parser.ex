defmodule Servo.Parser do
  alias Servo.Request

  def parse(request) do
    # Separate request body from headers
    [head, body] = String.split(request, "\n\n")
    
    # Separate request headers from request method line
    [request_line | header_lines] = String.split(head, "\n")

    [method, path, _] = String.split(request_line, " ")
    
    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], body)

    %Request{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end
  
  def parse_headers([h | t], headers) do
    [key, value] = String.split(h, ":")
    headers = Map.put(headers, key, value)
    parse_headers(t)
  end
  
  def parse_headers([], headers), do: headers
  
  def parse_params(_, _), do: %{}
  
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end
end
