defmodule Servo.Fetch do
  @moduledoc """
  An abstraction around how API client is called and how it's result is resolved
  """

  @doc """
  Spawns an async process
  """
  def async(f) do
    parent = self()

    spawn(fn -> send(parent, {self(), :result, f.()}) end)
  end
  
  @doc """
  Gets the result from an async process
  """
  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end
end
