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

  defp remove_whitespace(str) do
    String.replace(str, ~r{\s}, "")
  end
end
