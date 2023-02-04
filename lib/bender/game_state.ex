defmodule Bender.GameState do
  @moduledoc """
  Utilities for manipulating the game state.
  The server sends game state as JSON document.

  """

  alias Bender.{Mapper,Chat}

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

  def register(name, register_url, bot_url) do
    {:ok, {_status, _headers, body}} = :httpc.request(:post, # Method
      {register_url, # URL
       [], # Headers
       String.to_charlist("application/json"), # Content type to POST (must be an erlang list, not a binary)
       Jason.encode!(%{playerName: name, url: bot_url})}, # Body contents
      [], [sync: true]) # Http and other options

    gs = from_json(body)

    # Update map
    Mapper.map(get_in(gs, ["gameState", "map"]))
  end

  # Get position of thing as {x,y} tuple
  defp pos(%{"position" => %{"x" => x, "y" => y}}), do: {x,y}

  # Get direction from adjacent position
  defp dir({x1,y1},{x2,y2}) do
    cond do
      x1 < x2 -> "RIGHT"
      x2 < x1 -> "LEFT"
      y1 < y2 -> "DOWN"
      y2 < y1 -> "UP"
    end
  end

  def play(%{"gameState" => %{"items" => items}=gs, "playerId" => id, "playerState" => me}) do
    ##IO.puts("items: #{inspect(gs)}")
    item = hd(items) # Take first item
    item_pos = pos(item)
    my_pos = pos(me)

    ## Starting point, stupidly go to 1st item and try to get it.
    ## should take into account what is the best item to get you can afford
    ## if no items you can afford, go to exit

    cond do
      item_pos == my_pos ->
        Chat.say(id, "This is mine!")
        "PICK"
      true ->
        # Not at position, find path
        {:path, [^my_pos, next_pos | _ ]} = Mapper.path(my_pos, item_pos)
        dir(my_pos, next_pos)
    end
  end
end
