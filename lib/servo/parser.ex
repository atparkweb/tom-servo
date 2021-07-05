defmodule Servo.Parser do
  def parse(req) do
    [method, path, _] =
      req
        |> String.split("\n")
        |> List.first
        |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil }
  end
end
