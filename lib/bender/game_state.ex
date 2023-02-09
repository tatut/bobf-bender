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
    GenServer.start_link(__MODULE__, opts, name: :bender_gamestate)
  end

  defp poll(), do: :timer.send_after(100, :poll)

  def init(opts) do
    poll()
    {:ok, %{listeners: [], game_state: nil}}
  end

  def handle_info(:poll, %{listeners: listeners, game_state: old_gs}=state) do
    new_gs = Api.gamestate()
    old_round = get_in(old_gs, ["round"])
    new_round = get_in(new_gs, ["round"])
    if old_round != new_round do
      # Send message to all bots to play this round
      Enum.each(listeners, &send(&1, {:gamestate, new_gs}))
      #IO.puts("NEW ROUND! #{new_round}")
    end
    poll()
    {:noreply, %{state | game_state: new_gs}}
  end

  def handle_cast({:listen, pid}, %{listeners: l, game_state: gs}=state) do
    {:noreply, %{state | listeners: [pid | l]}}
  end

end
