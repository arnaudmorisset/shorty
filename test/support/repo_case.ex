defmodule Shorty.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Shorty.Repo

      import Ecto
      import Ecto.Query
      import Shorty.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Shorty.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Shorty.Repo, {:shared, self()})
    end

    :ok
  end
end
