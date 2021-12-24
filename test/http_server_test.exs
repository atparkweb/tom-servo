defmodule HttpServerTest do
  use ExUnit.Case

  alias Servo.Servers.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4001])

    urls = [
      "http://localhost:4001/bot_crew",
      "http://localhost:4001/bots",
      "http://localhost:4001/bots/1",
      "http://localhost:4001/api/bots"
    ]

    urls
    |> Enum.map(fn(url) -> Task.async(fn -> HTTPoison.get(url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end
end
