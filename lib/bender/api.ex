defmodule Bender.Api do
  @moduledoc """
  Server API handling.
  """

  defp url, do: Application.fetch_env!(:bender, :server_url)
  defp parse_response({:ok, {_status, _headers, body}}), do: Jason.decode!(body)

  # POST a payload to the given path on the server JSON and return parsed JSON response
  defp post(path, payload) do
    parse_response(
      :httpc.request(:post, {"#{url()}/#{path}", [],
                             'application/json',
                             Jason.encode!(payload)},
        [], [sync: true]))
  end

  # GET a path from the server and return parsed JSON response
  defp get(path) do
    parse_response(:httpc.request("#{url()}/#{path}"))
  end

  def register(name) do
    post("register", %{playerName: name})
  end

  def gamestate() do
    get("gamestate")
  end
end
