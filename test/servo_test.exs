defmodule ServoTest do
  use ExUnit.Case
  doctest Servo

  test "greets the world" do
    assert Servo.hello("Joel") == "Hello, Joel!"
  end
end
