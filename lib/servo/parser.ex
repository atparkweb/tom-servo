defmodule Servo.Parser do
  alias Servo.Request

  def parse(req) do
    [method, path, _] =
      req
        |> String.split("\n")
        |> List.first
        |> String.split(" ")

    %Request{
      method: method,
      path: path,
    }
  end
end
