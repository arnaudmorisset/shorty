defmodule Shorty.Router do
  use Plug.Router

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug(:match)
  plug(:dispatch)

  post("/domains", do: Shorty.Controllers.Domain.create(conn, conn.params))
end
