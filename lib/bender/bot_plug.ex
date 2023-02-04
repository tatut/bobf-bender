defmodule Bender.BotPlug do
  import Plug.Conn

  alias Bender.GameState, as: GS

   def init(options) do
    # initialize options
    options
  end

   def call(conn, _opts) do
     {:ok, body, conn} = read_body(conn, read_timeout: 1000)

     # Read game state from POSTed JSON
     gs = GS.from_json(body)

     # Decide next action
     action = GS.play(gs)

     conn
     |> put_resp_content_type("application/json")
     |> send_resp(200, Jason.encode!(action))
   end
end
