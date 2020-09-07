defmodule Shorty.Controller do
  import Plug.Conn

  def respond(conn, status, payload) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(payload))
  end
end
