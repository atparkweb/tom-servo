defmodule Api.Client do
  @moduledoc """
  A mock api client for making calls to backing service
  """

  def get_data(key) do
    content = %{
      one: "ONE",
      two: "TWO",
      three: "THREE"
    }

    # simulate a 6 second response time
    :timer.sleep(:timer.seconds(6))

    content[key]
  end
end
