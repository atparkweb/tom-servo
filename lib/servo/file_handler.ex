defmodule Servo.FileHandler do
  def handle_file({:ok, content}, req) do
    %{ req | status: 200, res_body: content }
  end
  
  def handle_file({:error, :enoent}, req) do
    %{ req | status: 404, res_body: "File not found!" }
  end
  
  def handle_file({:error, reason}, req) do
    %{ req | status: 500, res_body: "File error: #{reason}" }
  end
  
end
