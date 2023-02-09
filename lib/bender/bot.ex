defmodule Bender.Bot do
  @moduledoc """
  Bot is a process that receives new gamestate and plays a round.
  """
  alias Bender.{Mapper,Api}

  def start(opts) do
    name = opts[:name] || "Bender#{round(:rand.normal() * 10_000_000)}"
    %{"id" => id, "map" => map} = Api.register(name)
    state = %{id: id, name: name, map: Mapper.map(map)}
    pid = spawn(__MODULE__, :loop, [state])
    {:ok, pid}
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

  def loop(%{name: name, id: id}=state) do
    receive do
      {:gamestate, gs} ->
        case play(gs, state) do
          :dead ->
            IO.puts("#{name} has died, good night sweet prince!")

            {new_state, move} ->
            Api.move(id, move)
            loop(new_state)
        end
    after
      5000 -> IO.puts("No gamestate received in 5s, shutting down #{name} (id: #{id})")
    end
  end

  defp play(%{"players" => players}=gs, %{name: name}=state) do
    # Find myself by name in the list of players
    case Enum.find(players, fn %{"name" => n} -> n == name end) do
      nil -> :dead
      me -> play(me, gs, state)
    end
  end

  defp play(me, %{"items" => items, "players" => players}=gs, %{id: id, name: name, map: map}=state) do

    # Take first item
    item = hd(items)
    IO.puts("ME: #{inspect(me)}, ITEM: #{inspect(item)}")
    item_pos = pos(item)
    my_pos = pos(me)

    ## Starting point, stupidly go to 1st item and try to get it.
    ## should take into account what is the best item to get you can afford
    ## if no items you can afford, go to exit

    cond do
      item_pos == my_pos ->
        Api.say(id, "This is mine!")
        {state, "PICK"}
      true ->
        # Not at position, find path
        {:path, [^my_pos, next_pos | _ ]} = Mapper.path(map, my_pos, item_pos)
        {state, dir(my_pos, next_pos)}
    end
  end
end
