defmodule Bender.GameState do
  @moduledoc """
  Utilities for manipulating the game state.
  The server sends game state as JSON document.
  """

  def from_json(json) do
    Jason.decode!(json)
  end

  def to_json(gs) do
    Jason.encode!(gs)
  end

  def from_example() do
    {:ok, str} = :file.read_file("example.json")
    from_json(str)
  end

  def play(gs) do
    "RIGHT"
  end
end
