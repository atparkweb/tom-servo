defmodule Recurse do
  @moduledoc """
  Simple recursive looping examples
  """
  
  @doc """
  Sum a list of integers
  
  ## Examples
  
       iex> Recurse.sum([1, 2, 3])
       6

  """
  def sum(xs) do
    sum_r(xs, 0)
  end
  
  defp sum_r([h | t], total) do
    sum_r(t, h + total)
  end

  defp sum_r([], total), do: total
  
  @doc """
  Triple each integer in a list and return a new list
  
  ## Examples
  
       iex> Recurse.triple([1, 2, 3])
       [3, 6, 9]
       
       iex> Recurse.triple([10, 20, 30])
       [30, 60, 90]
  """
  def triple(xs) do
    triple_r(xs, [])
  end
  
  defp triple_r([h | t], result) do
    triple_r(t, [h * 3 | result])
  end
  
  defp triple_r([], result), do: result |> Enum.reverse
  
  def my_map(xs, iterator) do
    my_map_r(xs, iterator, [])
  end
  
  defp my_map_r([h | t], iterator, result) do
    my_map_r(t, iterator, [iterator.(h) | result])
  end

  defp my_map_r([], _, result), do: result |> Enum.reverse
end
