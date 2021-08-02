defmodule HandlerTest do
  use ExUnit.Case
  
  import Servo.Handler, only: [handle: 1]
  
  test "GET /bot_crew" do
    request = """
    GET /bot_crew HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    
    response = handle(request)
    
    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 32\r
    \r
    ✅\r
    Cambot, Gypsy, Tom Servo, Crow
    """
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
    Content-Length: 164\r
    \r
    ✅\r
    <h1>Robot Roll Call!</h1>

    <ul>
      <li>Cambot is Orange</li>
      <li>Gypsy is Purple</li>
      <li>Tom Servo is Red</li>
      <li>Crow is Yellow</li>
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
    Content-Length: 69\r
    \r
    ✅\r
    <h1>Show Bot</h1>

    <p>
      ID: 1
      Name: Cambot
      Color: Orange
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
    Content-Length: 31\r
    \r
    ✅\r
    Created a gold bot named C3PO
    """
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
    Content-Length: 34\r
    \r
    ✅\r
    <h1>Welcome to my homepage</h1>
    """
    
    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /pages/new" do
    request = """
    GET /pages/new HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 154\r
    \r
    ✅\r
    <form action="/bots" method="POST">
      <label>
        Name: 
        <input type="text" name="name">
      </label>
      <input type="submit" value="Add Bot">
    </form>
    """
    
    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(str) do
    String.replace(str, ~r{\s}, "")
  end
end
