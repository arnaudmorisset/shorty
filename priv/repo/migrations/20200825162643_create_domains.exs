defmodule Shorty.Repo.Migrations.CreateDomains do
  use Ecto.Migration

  def change do
    create table(:domains, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:url, :string, null: false)
      add(:short_tag, :string, null: false)

      timestamps()
    end
  end
end
