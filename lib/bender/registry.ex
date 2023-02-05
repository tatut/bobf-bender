defmodule Bender.Registry do
  @moduledoc """
  Registry for bots by player id, registers PID of bot process by player id.
  """

  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: :bender_registry)
  end

  def init([url]) do
    {:ok, %{url: url, bots: %{}}}
  end

  @doc "Start new bot and register its PID in the registry for callbacks"
  def register(opts) do
    {:ok, pid} = GenServer.start_link(Bender.GameState, opts)
    GenServer.call(:bender_registry, {:register, opts[:name], pid})
  end

  def get(name) do
    GenServer.call(:bender_registry, {:get, name})
  end

  def handle_call({:register, name, pid}, _from, state) do
    {:reply, :ok,
     state
     |> Map.update!(:bots, &(Map.put(&1, name, pid)))}
  end

  def handle_call({:get, name}, _from, %{bots: bots}=state) do
    {:reply, bots[name], state}
  end
end
