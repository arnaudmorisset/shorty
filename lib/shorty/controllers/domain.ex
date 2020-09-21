defmodule Shorty.Controllers.Domain do
  import Shorty.Controller

  def create(conn, params) do
    # TODO(arnaud): Isolate business logic inside a workflow with input validation.
    original_url = params["url"] || ""

    case find_or_create_domain(original_url) do
      {:ok, domain} ->
        respond(conn, 200, %{
          original_url: domain.url,
          short_tag: domain.short_tag,
          shorten_url: build_shorten_url(domain.short_tag)
        })

      {:error, %Ecto.Changeset{errors: [url: {_, _}]}} ->
        respond(conn, 422, %{error: "unprocessable_entity", message: "The URL is not valid"})
    end
  end

  def show(conn, params) do
    # TODO(arnaud): Isolate business logic inside a workflow with input validation.
    short_tag = params["short_tag"] || ""

    case Shorty.Queries.Domain.by_short_tag(short_tag) do
      {:ok, domain} ->
        redirect(conn, domain.url)

      {:error, %Shorty.Repo.NotFoundError{}} ->
        respond(conn, 404, %{error: "not_found", message: "The original URL cannot be found"})
    end
  end

  defp find_or_create_domain(original_url) do
    with {:ok, domain} <- Shorty.Queries.Domain.by_original_url(original_url) do
      {:ok, domain}
    else
      {:error, %Shorty.Repo.NotFoundError{}} ->
        %{url: original_url, short_tag: generate_short_tag()}
        |> Shorty.Models.Domain.changeset_creation()
        |> Shorty.Commands.Domain.create()
    end
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
    cowboy_port = Application.get_env(:shorty, :cowboy_port, 4000)

    if Mix.env() != :prod do
      "#{scheme}://#{domain_name}:#{cowboy_port}/#{short_tag}"
    else
      "#{scheme}://#{domain_name}/#{short_tag}"
    end
  end
end
