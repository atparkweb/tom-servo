defmodule Common.Recurse do
  def sum(xs) do
    sum_(xs, 0)
  end
  
  defp sum_([h | t], total) do
    sum_(t, h + total)
  end

  defp sum_([], total), do: total
  

  def triple(xs) do
    triple_(xs, [])
  end
  
  defp triple_([h | t], result) do
    triple_(t, [h * 3 | result])
  end
  
  defp triple_([], result), do: result |> Enum.reverse
end
