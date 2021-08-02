defmodule Servo.Request do
  @moduledoc """
    Struct representing HTTP request/response object
  """
  defstruct headers: %{},
            method: "",
            params: %{},
	    path: "",
            res_content_type: "text/html", # TODO: make this general res_headers map
	    res_body: "",
	    status: nil
  
  def full_status(req) do
    "#{req.status} #{status_desc(req.status)}"
  end

  defp status_desc(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
