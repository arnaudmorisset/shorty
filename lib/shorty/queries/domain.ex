defmodule Shorty.Queries.Domain do
  import Ecto.Query

  def by_original_url(original_url) do
    query = from(d in Shorty.Models.Domain, where: d.url == ^original_url)

    Shorty.Repo.select_one(query)
  end
end
