defmodule Servo.Utils do
  @moduledoc "Utilities for transforming requests"

  require Logger

  @doc "Uses Logger module to print requests."
  def log(req) do
    Logger.info(req)
    req
  end

  @doc "Logs 404 requests"
  def trace(%{ status: 404, path: path } = req) do
    Logger.warn("Warning: undefined path: #{path}")
    req
  end
  def trace(req), do: req
  
  @doc "Converts id query string parameter to a path parameter."
  def rewrite_path(%{ path: path } = req) do
    regex = ~r{\/(?<name>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(req, captures)
  end
  def rewrite_path(req), do: req

  @doc "Converts regular expression captures map to a path"
  defp rewrite_path_captures(req, %{ "name" => name, "id" => id }) do
    %{ req | path: "/#{name}/#{id}" }
  end
  defp rewrite_path_captures(req, nil), do: req

  
  defp status_icon(200), do: "✅ "
  defp status_icon(201), do: "✅ "
  defp status_icon(_), do: "⛔ "

  @doc "Adds an emoji to the response body based on the response status code."
  def emojify(%{ status: status } = req) do
    %{ req | resp_body: "#{status_icon(status)}\n" <> req.resp_body }
  end
  
end
