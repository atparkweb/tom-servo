defmodule MessageServerTest do
  use ExUnit.Case

  alias Servo.MessageServer

  test "should cache the 3 most recent messages" do
    MessageServer.start()

    MessageServer.create_message("user1", "hello")
    MessageServer.create_message("user2", "hi")
    MessageServer.create_message("user3", "aloha")
    MessageServer.create_message("user1", "goodbye")
    MessageServer.create_message("user2", "bye")
    MessageServer.create_message("user3", "aloha")

    recent = %MessageServer.State{
      cache_size: 3,
      messages: [
        {"user3", "aloha"},
        {"user2", "bye"},
        {"user1", "goodbye"}
      ]
    }

    assert MessageServer.recent_messages() == recent
  end
end
