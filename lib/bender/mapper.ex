defmodule Bender.Mapper do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: :bender_mapper)
  end

  def init(arg) do
    IO.puts(inspect(arg))
    {:ok, %{map: nil}}
  end

  defp neighbors({x,y}) do
    [{x-1,y}, {x+1,y}, {x,y-1}, {x,y+1}]
  end

  defp generate_map_digraph(%{"tiles" => rows, "exit" => %{"x" => exit_x, "y" => exit_y}}) do
    g = :digraph.new()

    # parse map into set of available positions
    set =
    for {row,y} <- Enum.with_index(rows),
      {tile, x} <- Enum.with_index(String.to_charlist(row)),
      # Only consider floor tiles to be available
      tile == ?_, do: {x,y}, into: MapSet.new()

    # Create nodes for all available positions and links to adjacent ones
    for p <- set do
      for n <- neighbors(p), MapSet.member?(set, n) do
        :digraph.add_vertex(g, p)
        :digraph.add_vertex(g, n)
        :digraph.add_edge(g, p, n)
      end
    end

    # Add special :exit node and links to it from all its neighbors
    :digraph.add_vertex(g, :exit, {exit_x, exit_y})
    for n <- neighbors({exit_x,exit_y}), do: :digraph.add_edge(g, n, :exit)

    # Return the new digraph
    g
  end

  defp calculate_path(m, from, to) do
    case :digraph.get_short_path(m, from, to) do
      false -> :no_path
      path ->
        {:path, for v <- path do
              case v do
                # Turn reference to exit vertex into {x,y} like other vertices
                :exit ->
                  {_, exitv} = :digraph.vertex(m, :exit)
                  exitv
                v -> v
              end
            end}
    end
  end

  def handle_call({:map, map_json}, _from, %{map: map}=state) do
    # Close old ETS table, if any
    if map != nil do
      :digraph.delete(map)
    end

    new_map = generate_map_digraph(map_json)

    {:reply, :updated, %{ state | map: new_map}}
  end

  def handle_call({:path, from, to}, _from, %{map: map}=state) do
    path = calculate_path(map, from, to)
    {:reply, path, state}
  end

  def handle_call(:debug, _from, %{map: map}=state) do
    IO.puts("Vertices: #{inspect(:digraph.vertices(map))}")
    {:reply, :ok, state}
  end

  def map(map_json) do
    map(:bender_mapper, map_json)
  end

  def path(from, to) do
    path(:bender_mapper, from, to)
  end

  def map(mapper, map_json) do
    GenServer.call(mapper, {:map, map_json})
  end

  def path(mapper, from, to) do
    GenServer.call(mapper, {:path, from, to})
  end

end
