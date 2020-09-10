defmodule Shorty.Repo.Migrations.AddUnicityConstraintOnURL do
  use Ecto.Migration

  def change do
    create(unique_index(:domains, [:url]))
  end
end
