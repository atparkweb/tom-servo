defmodule Servo.Fetch do
  @moduledoc """
  An abstraction around how API client is called and how it's result is resolved
  """

  alias Servo.ApiClient

  @doc """
  Spawns an simulated async call to an external API
  """
  def async(name) do
    parent = self()

    spawn(fn -> :timer.sleep(2000) ; send(parent, ApiClient.get_data(name)) end)
  end
  
  @doc """
  Gets the result from an async call
  """
  def get_result do
    receive do {:result, data} -> data end
  end
end
