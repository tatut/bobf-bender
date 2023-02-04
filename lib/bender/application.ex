defmodule Bender.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    url = Application.fetch_env!(:bender, :server_url)
    children = [
      # Starts a worker by calling: Bender.Worker.start_link(arg)
      {Bender.Mapper, []},
      {Bender.Chat, [url]},
      {Bandit, plug: Bender.BotPlug, scheme: :http, options: [port: 4000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bender.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
