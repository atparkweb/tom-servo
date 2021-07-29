defmodule Servo.Parser do
  @moduledoc """
  Example HTTP Request:


  """

  alias Servo.Request

  @doc """
  Convert HTTP Request string to a Request struct
  
  Returns: `%Request{}`
  
  """
  def parse(request) do
    # Separate request body from headers
    [head, body] = String.split(request, "\n\n")
    
    # Separate request headers from request method line
    [request_line | header_lines] = String.split(head, "\n")

    [method, path, _] = String.split(request_line, " ")
    
    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], body)

    %Request{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end
  
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ":")
      Map.put(headers, key, String.trim(value))
    end)
  end
  
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}
end
