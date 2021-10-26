defmodule Servo.ApiClient do
  @moduledoc """
  A mock api client for making calls to backing service
  """
  
  def get_data(key) do
    content = %{
      one: "ONE",
      two: "TWO",
      three: "THREE"
    }

    {:result, content[key]}
  end
end
