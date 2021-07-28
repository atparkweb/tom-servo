defmodule Utils do
  @moduledoc """
  Some example function to practive Elixir
  """
  
  @doc """
  Builds a standard deck of 52 as a list of tuples
  
  ## Returns: [{ "3", "♣" }, { "3", "♠" }, etc. ]
  """
  def get_deck do
    ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    suits = ["♣", "♦", "♥", "♠" ]

    deck = for rank <- ranks, suit <- suits, do: { rank, suit }
    
    deck
  end
  
  def deal(deck) do
    deck
    |> Enum.shuffle
    |> Enum.take(13)
    |> IO.inspect
  end
  
  def deal_four_hands(deck) do
    deck
    |> Enum.shuffle
    |> Enum.chunk_every(13)
    |> IO.inspect
  end
end
