defmodule Servo do
  alias Servo.Handler

  def get_form do
      req = """
      GET /bots/new HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*
      """
      
      IO.puts Handler.handle(req)
  end
  
  def all_bots do
    req = """
    GET /bots HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    IO.puts Handler.handle(req)
  end
  
  def get_bot(id) do
    req = """
    GET /bots/#{id} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    IO.puts Handler.handle(req)
  end
  
  def get_page(name) do
    req = """
    GET /pages/#{name} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    
    IO.puts Handler.handle(req)
  end
  
  def create_bot(id, name, color) do
    req = """
    POST /bots HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    id=#{id}&name=#{name}&color=#{color}
    """

    IO.puts Handler.handle(req)
  end
  
  def all_humans do
    req = """
    GET /humans HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    IO.puts Handler.handle(req)
  end
end
