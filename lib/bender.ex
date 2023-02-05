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

    Bender.Registry.register([name: name , register_url: register_url, bot_url: bot_url])
  end
end
