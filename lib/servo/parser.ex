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
    [head, body] = String.split(request, "\r\n\r\n")
    
    # Separate request headers from request method line
    [request_line | header_lines] = String.split(head, "\r\n")

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
  
  @doc """
  Converts HTTP header lines to a Map
  
  ## Examples
      iex> header_lines = ["Host: example.com", "User-Agent: ExampleBrowser/1.0"]
      iex> Servo.Parser.parse_headers(header_lines)
      %{ "Host" => "example.com", "User-Agent" => "ExampleBrowser/1.0" }
  """
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ":")
      Map.put(headers, key, String.trim(value))
    end)
  end
  
  @doc """
  Parses a param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.
  
  ## Examples
      iex> params_string = "name=C3PO&color=Gold"
      iex> Servo.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{ "name" => "C3PO", "color" => "Gold" }
      iex> Servo.Parser.parse_params("multipart/form-data", params_string)
      %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}
end
