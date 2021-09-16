defmodule Servo.ApiClient do
  @moduledoc """
  A mock api client for making calls to backing service
  """
  
  def get_data(title) do
    content = %{
      star_wars: ["R2D2", "C3PO", "BB8"],
      transformers: ["Star Scream", "Megatron", "Optimus", "Bumblebee"],
      futurama: ["Bender", "Clamps", "Hedonism Bot", "Devil"]
    }

    {:data, content[title]}
  end
end
