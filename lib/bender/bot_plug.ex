defmodule Bender.BotPlug do
  import Plug.Conn

  alias Bender.Registry, as: Reg

   def init(options) do
    # initialize options
    options
  end

   def call(conn, _opts) do
     {:ok, body, conn} = read_body(conn, read_timeout: 1000)

     # Read game state from POSTed JSON
     gs = Jason.decode!(body)

     # Get the bot by name
     name = get_in(gs, ["playerState", "name"])
     bot = Reg.get(name)

     # Decide next action
     action = GenServer.call(bot, {:play, gs})

     conn
     |> put_resp_content_type("application/json")
     |> send_resp(200, Jason.encode!(action))
   end
end
