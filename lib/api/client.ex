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

    # simulate a delayed response time
    :timer.sleep(:timer.seconds(2))

    content[key]
  end
end
