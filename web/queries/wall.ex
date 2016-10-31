defmodule PhoenixSocial.Queries.Wall do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Comment}

  def posts(profile, pagination) do
    query =
      from p in Post,
        join: pa in assoc(p, :author),
        where: [profile_id: ^profile.id],
        order_by: [desc: :id],
        offset: ^pagination.offset,
        limit: ^pagination.limit,
        preload: [
          author: pa,
          comments: ^comments_query]

    Repo.all(query)
  end

  defp comments_query do
    from c in Comment,
      join: ca  in assoc(c, :author),
      order_by: :id,
      preload: [author: ca]
  end
end
