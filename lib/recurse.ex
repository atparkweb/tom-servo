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
    sum_(xs, 0)
  end
  
  defp sum_([h | t], total) do
    sum_(t, h + total)
  end

  defp sum_([], total), do: total
  
  @doc """
  Triple each integer in a list and return a new list
  
  ## Examples
  
       iex> Recurse.triple([1, 2, 3])
       [3, 6, 9]
       
       iex> Recurse.triple([10, 20, 30])
       [30, 60, 90]
  """
  def triple(xs) do
    triple_(xs, [])
  end
  
  defp triple_([h | t], result) do
    triple_(t, [h * 3 | result])
  end
  
  defp triple_([], result), do: result |> Enum.reverse
end
