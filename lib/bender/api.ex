defmodule Bender.Api do
  @moduledoc """
  Server API handling.
  """

  defp url, do: Application.fetch_env!(:bender, :server_url)

  defp parse_response({:ok, {{_, 200, _}, _, []}}), do: :ok
  defp parse_response({:ok, {_status, _headers, body}=resp}), do: Jason.decode!(body)

  # POST a payload to the given path on the server JSON and return parsed JSON response
  defp call(method, path, payload) do
    parse_response(
      :httpc.request(method, {"#{url()}/#{path}", [],
                              'application/json',
                              Jason.encode!(payload)},
        [], [sync: true]))
  end

  # GET a path from the server and return parsed JSON response
  defp get(path) do
    parse_response(:httpc.request("#{url()}/#{path}"))
  end

  def register(name) do
    call(:post, "register", %{playerName: name})
  end

  def gamestate() do
    get("gamestate")
  end

  def move(player_id, move) do
    call(:put, player_id <> "/move", move)
  end

  def say(player_id, msg) do
    call(:post, player_id <> "/say", msg)
  end
end
