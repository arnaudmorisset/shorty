defmodule Shorty.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug(:match)
  plug(:dispatch)

  post("/domains", do: Shorty.Controllers.Domain.create(conn, conn.params))

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
