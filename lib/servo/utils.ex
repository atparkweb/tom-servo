defmodule Servo.Utils do
  @moduledoc "Utilities for transforming requests"
  
  alias Servo.Request

  require Logger

  @doc "Uses Logger module to print requests."
  def log(%Request{} = req) do
    if Mix.env == :dev do
      Logger.info(req)
    end
    req
  end


  @doc "Logs 404 requests"
  def trace(%Request{ status: 404, path: path } = req) do
    Logger.warn("Warning: undefined path: #{path}")
    req
  end

  def trace(%Request{} = req), do: req

  
  @doc "Converts id query string parameter to a path parameter."
  def rewrite_path(%Request{ path: path } = req) do
    regex = ~r{\/(?<name>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(req, captures)
  end

  def rewrite_path(%Request{} = req), do: req


  defp rewrite_path_captures(%Request{} = req, %{ "name" => name, "id" => id }) do
    %{ req | path: "/#{name}/#{id}" }
  end

  defp rewrite_path_captures(%Request{} = req, nil), do: req

  
  defp status_icon(200), do: "✅"
  defp status_icon(201), do: "✅"
  defp status_icon(_), do: "⛔"

  @doc "Adds an emoji to the response body based on the response status code."
  def emojify(%Request{ status: status } = req) do
    %Request{ req | res_body: "#{status_icon(status)}\r\n" <> req.res_body }
  end
  
end
