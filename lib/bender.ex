defmodule Bender do
  @moduledoc """
  Start a bot by giving server url and options.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Bender.hello()
      :world

  """
  def go(opts \\ []) do
    {:ok, pid} = Bender.Bot.start(opts)
    GenServer.cast(:bender_gamestate, {:listen, pid})
  end
end
