defmodule Shorty.Controllers.Domain do
  import Shorty.Controller

  def create(conn, params) do
    case create_domain(params) do
      {:ok, domain} ->
        respond(conn, 200, %{
          original_url: domain.url,
          short_tag: domain.short_tag,
          shorten_url: build_shorten_url(domain.short_tag)
        })

      {:error, %Ecto.Changeset{errors: [url: {"can't be blank", [validation: :required]}]}} ->
        respond(conn, 422, %{error: "unprocessable_entity", message: "The URL is missing"})

      {:error, %Ecto.Changeset{errors: [url: {_, _}]}} ->
        respond(conn, 422, %{error: "unprocessable_entity", message: "The URL is not valid"})
    end
  end

  defp create_domain(params) do
    %{url: params["url"], short_tag: generate_short_tag()}
    |> Shorty.Models.Domain.changeset_creation()
    |> Shorty.Commands.Domain.create()
  end

  defp generate_short_tag do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, 16)
  end

  defp build_shorten_url(short_tag) do
    scheme = Application.get_env(:shorty, :scheme, "https")
    domain_name = Application.get_env(:shorty, :domain_name, "localhost")
    cowboy_port = Application.get_env(:shorty, :cowboy_port, 8080)

    "#{scheme}://#{domain_name}:#{cowboy_port}/#{short_tag}"
  end
end
