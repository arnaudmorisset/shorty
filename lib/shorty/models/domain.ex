defmodule Shorty.Models.Domain do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "domains" do
    field(:url, :string, null: false)
    field(:short_tag, :string, null: false)

    timestamps()
  end

  def changeset_creation(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  defp changeset(url, params) do
    url
    |> cast(params, [:url, :short_tag])
    |> validate_required([:url, :short_tag])
    |> validate_url(:url)
  end

  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          [{field, Keyword.get(opts, :message, "is missing a scheme (e.g. https)")}]

        %URI{host: nil} ->
          [{field, Keyword.get(opts, :message, "is missing a host")}]

        _ ->
          []
      end
    end)
  end
end
