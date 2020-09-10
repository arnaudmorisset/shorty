defmodule Shorty.Repo do
  use Ecto.Repo,
    otp_app: :shorty,
    adapter: Ecto.Adapters.Postgres

  defmodule NotFoundError do
    defstruct([:code, :message])
  end

  def select_one(query) do
    case Shorty.Repo.one(query) do
      nil ->
        {:error,
         %__MODULE__.NotFoundError{code: :not_found, message: "the resource was not found"}}

      result ->
        {:ok, result}
    end
  end
end
