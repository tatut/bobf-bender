defmodule Bender.GameState do
  @moduledoc """

  Polls new game state from server.
  Notifies all registered listeners of new state.

  Utilities for manipulating the game state.
  The server sends game state as JSON document.

  """

  use GenServer
  alias Bender.{Mapper,Chat,Api}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  defp poll(), do: :timer.send_after(333, :poll)

  def init(opts) do
    poll()
    {:ok, %{bots: [], game_state: nil}}
  end

  def handle_info(:poll, %{bots: bots, game_state: old_gs}=state) do
    new_gs = Api.gamestate()
    old_round = get_in(old_gs, ["round"])
    new_round = get_in(new_gs, ["round"])
    if old_round != new_round do
      # Send message to all bots to play this round
      Enum.each(bots, &GenServer.cast(&1, {:play, new_gs}))
      IO.puts("NEW ROUND! #{new_round}")
    end
    poll()
    {:noreply, %{state | game_state: new_gs}}
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

  defp play(_state, %{"gameState" => %{"items" => items}=gs, "playerId" => id, "playerState" => me}) do
    ##IO.puts("items: #{inspect(gs)}")
    item = hd(items) # Take first item
    item_pos = pos(item)
    my_pos = pos(me)
    map_name = get_in(gs, ["map", "name"])
    ## Starting point, stupidly go to 1st item and try to get it.
    ## should take into account what is the best item to get you can afford
    ## if no items you can afford, go to exit

    cond do
      item_pos == my_pos ->
        Chat.say(id, "This is mine!")
        {me, "PICK"}
      true ->
        # Not at position, find path
        {:path, [^my_pos, next_pos | _ ]} = Mapper.path(map_name, my_pos, item_pos)
        {me, dir(my_pos, next_pos)}
    end
  end

  def handle_call({:play, new_game_state}, _from, state) do
    {new_state, action} = play(state, new_game_state)
    {:reply, action, new_state}
  end

end
