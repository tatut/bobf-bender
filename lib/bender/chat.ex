defmodule Bender.Chat do

  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, name: :bender_chat)
  end

  def init(url) do
    {:ok, %{url: url}}
  end

  def handle_cast(%{player: id, msg: msg}, %{url: url}=state) do
    :httpc.request(:post, {"#{url}/#{id}/say", [], 'text/plain', msg}, [], [])
    {:noreply, state}
  end

  def say(id, msg) do
    GenServer.cast(:bender_chat, %{player: id, msg: msg})
  end

end
