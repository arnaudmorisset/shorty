defmodule Shorty.Controller do
  import Plug.Conn

  def respond(conn, status, payload) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(payload))
  end

  def redirect(conn, url_to_redirect) do
    conn
    |> put_resp_header("location", url_to_redirect)
    |> send_resp(301, "")
  end
end
