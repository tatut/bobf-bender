defmodule Bender.Mapper do
  alias Graph, as: G

  defp neighbors(g, {x,y}) do
    for v <- [{x-1,y}, {x+1,y}, {x,y-1}, {x,y+1}], G.has_vertex?(g, v),
      into: [], do: v
  end

  def map(%{"tiles" => rows, "exit" => %{"x" => exit_x, "y" => exit_y}}) do
    # parse map into set of available positions
    g = for {row,y} <- Enum.with_index(rows),
      {tile, x} <- Enum.with_index(String.to_charlist(row)),
      # Only consider floor tiles to be available
      tile == ?_, reduce: G.new() do
        g -> G.add_vertex(g, {x,y})
    end

    # Create nodes for all available positions and links to adjacent ones
    g =
    for p <- Graph.vertices(g), n <- neighbors(g, p),
      reduce: g do
        g -> G.add_edge(g, p, n)
    end

    # Add special :exit node and links to it from all its neighbors
    g =
    for n <- neighbors(g, {exit_x,exit_y}), reduce: G.add_vertex(g, :exit, [at: {exit_x, exit_y}]) do
      g -> G.add_edge(g, n, :exit)
    end

    # Return the new graph
    g
  end

  @spec path(Graph.t(), any, any) :: :no_path | {:path, list}
  def path(m, from, to) do
    #IO.puts("PATH from #{inspect(from)} => to #{inspect(to)}")
    case G.get_shortest_path(m, from, to) do
      nil -> :no_path
      path ->
        {:path, for v <- path do
              case v do
                # Turn reference to exit vertex into {x,y} like other vertices
                :exit ->
                  G.vertex_labels(m, :exit)[:at]
                v -> v
              end
            end}
    end
  end

end
