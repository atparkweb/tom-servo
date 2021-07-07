defmodule Servo.Request do
  @moduledoc """
    Struct representing HTTP request/response object
  """
  defstruct [
    method: "",
    path: "",
    res_body: "",
    status: nil
  ]
end
