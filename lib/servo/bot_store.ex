defmodule Servo.BotStore do
  @moduledoc """
  Mock data store to test with. To be replaced with backing service

  """

  alias Servo.Bot
  
  @doc """
  Get a list of all the Bots
  """
  def list_bots do
    [
      %Bot{ id: 1, name: "Cambot", color: "Orange"},
      %Bot{ id: 2, name: "Gypsy", color: "Purple"},
      %Bot{ id: 3, name: "Tom Servo", color: "Red"},
      %Bot{ id: 4, name: "Crow", color: "Yellow"}
    ]
  end
  
  @doc """
  Get a single bot by ID
  """
  def get_bot(id) when is_integer(id) do
    Enum.find(list_bots(), fn(b) -> b.id == id end)
  end
  
  def get_bot(id) when is_binary(id) do
    id
    |> String.to_integer
    |> get_bot
  end
end
