defmodule Shorty.Commands.Domain do
  def create(changeset) do
    Shorty.Repo.insert(changeset)
  end
end
