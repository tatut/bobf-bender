defmodule Bender.Bot do

  alias Bender.{Chat,Mapper,Api}

  use GenServer

  def init(opts) do
    name = opts[:name] || "Bender#{round(:rand.normal() * 10_000_000)}"
    %{"id" => id, "map" => map} = Api.register(name)
    Bender.Mapper.map(map)
    {:ok, %{id: id, name: name, map: get_in(map, ["name"])}}
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

  defp play(%{"players" => players}=gs, %{id: id, name: name, map: map_name}=state) do
    # Find myself by name in the list of players
    case Enum.find(players, fn %{"name" => n} -> n == name end) do
      nil -> :dead
      me -> play(me, gs, state)
    end
  end

  defp play(me, %{"items" => items, "players" => players}=gs, %{id: id, name: name, map: map_name}=state) do

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
        {:path, [^my_pos, next_pos | _ ]} = Mapper.path(map_name, my_pos, item_pos)
        {state, dir(my_pos, next_pos)}
    end
  end

  def handle_cast({:gamestate, gamestate}, %{id: id, name: name}=state) do
    case play(gamestate, state) do
      :dead -> {:stop, :dead, %{name: name}}
      {new_state, move} ->
        Api.move(id, move)
        {:noreply, new_state}
    end
  end

  def terminate(reason, %{name: name}) do
    IO.puts("#{name} has died due to #{reason}, good night sweet prince!")
  end
end
