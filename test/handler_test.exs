defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servo.Handler, only: [handle: 1]

  alias Servo.Servers.HttpServer
  alias Servo.Servers.CacheServer
  alias Servo.HttpClient

  def start_server do
    spawn(HttpServer, :start, [4000])
    spawn(CacheServer, :start, [])
  end

  test "GET /api-data" do
    start_server()

    request = """
    GET /api-data HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 21\r
    \r
    ["ONE", "TWO", "THREE"]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bots" do
    request = """
    GET /bots HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 189\r
    \r
    <h1>Robot Roll Call!</h1>

    <ul>
      <li>Cambot is orange</li>
      <li>Gypsy is purple</li>
      <li>Tom Servo is red</li>
      <li>Crow is yellow</li>
      <li>C3PO is gold</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bots/:id" do
    request = """
    GET /bots/1 HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 67\r
    \r
    <h1>Show Bot</h1>

    <p>
      ID: 1
      Name: Cambot
      Color: orange
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bots" do
    request = """
    POST /bots HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Content-Type: application/x-www-form-urlencoded\r
    Accept: */*\r
    \r
    name=C3PO&color=gold
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Created a gold bot named C3PO
    """
  end

  test "DELETE /bots/1" do
    request = """
    DELETE /bots/1 HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Removing a bot is not allowed
    """
  end

  test "GET /api/bots" do
    request = """
    GET /api/bots HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 289\r
    \r
    [
      { \"name\": \"Cambot\", \"is_active\": true, \"id\": 1, \"color\": \"orange\" },
      { \"name\": \"Gypsy\", \"is_active\": true, \"id\": 2, \"color\": \"purple\" },
      { \"name\": \"Tom Servo\", \"is_active\": true, \"id\": 3, \"color\": \"red\" },
      { \"name\": \"Crow\", \"is_active\": true, \"id\": 4, \"color\": \"yellow\" },
      { \"name\": \"C3PO\", \"is_active\": true, \"id\": 5, \"color\": \"gold\" }
    ]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bots" do
    request = """
    POST /api/bots HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "R2D2", "color": "blue"}
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 201 Created\r
    Content-Type: application/json\r
    Content-Length: 40\r
    \r
    Created a bot named R2D2 with color blue
    """

    assert response == expected_response
  end


  test "GET /pages/home" do
    request = """
    GET /pages/home HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 70\r
    \r
    <h1>Welcome to my homepage</h1>
    <p><a href="/pages/faq">faq</a></p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(str) do
    String.replace(str, ~r{\s}, "")
  end
end
