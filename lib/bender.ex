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
    name = opts[:name] || "Bender#{round(:rand.normal() * 10_000_000)}"
    register_url = opts[:register_url] || "http://localhost:8080/register"
    bot_url = opts[:bot_url] || "http://localhost:4000/"

    result = :httpc.request(:post, # Method
      {register_url, # URL
       [], # Headers
       String.to_charlist("application/json"), # Content type to POST (must be an erlang list, not a binary)
       Jason.encode!(%{playerName: name, url: bot_url})}, # Body contents
      [], [sync: true]) # Http and other options

    IO.puts(inspect(result))

  end
end
