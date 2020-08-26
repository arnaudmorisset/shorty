defmodule Shorty.Controllers.Domain do
  import Plug.Conn

  def create(conn, params) do
    with {:ok, domain} <- create_domain(params),
         {:ok, json} <- to_outside(domain) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, json)
    end
  end

  defp create_domain(params) do
    %{url: params["url"], short_tag: generate_short_tag()}
    |> Shorty.Models.Domain.changeset_creation()
    |> Shorty.Commands.Domain.create()
  end

  defp to_outside(domain) do
    %{short_tag: domain.short_tag}
    |> Jason.encode()
  end

  defp generate_short_tag do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, 16)
  end
end
