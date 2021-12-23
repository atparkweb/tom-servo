defmodule Servo.Resources.BotStore do
  @moduledoc """
  Mock data store to test with. To be replaced with backing service

  """

  alias Servo.Resources.Bot

  @doc """
  Get a list of all the Bots
  """
  def list_bots do
    Path.expand("../../../db", __DIR__)
    |> Path.join("bots.json")
    |> read_json
    |> Poison.decode!(as: %{"bots" => [%Bot{}]})
    |> Map.get("bots")
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents
      {:error, reason} ->
        IO.inspect "Error reading #{source}: #{reason}"
        "[]"
    end
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
