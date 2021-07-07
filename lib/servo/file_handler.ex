defmodule Servo.FileHandler do
  alias Servo.Request

  def handle_file({:ok, content}, %Request{} = req) do
    %Request{ req | status: 200, res_body: content }
  end
  
  def handle_file({:error, :enoent}, %Request{} = req) do
    %Request{ req | status: 404, res_body: "File not found!" }
  end
  
  def handle_file({:error, reason}, %Request{} = req) do
    %Request{ req | status: 500, res_body: "File error: #{reason}" }
  end
  
end
