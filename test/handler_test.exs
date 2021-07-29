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
end
