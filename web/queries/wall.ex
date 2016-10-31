defmodule PhoenixSocial.Queries.Wall do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Comment}

  def posts(profile, pagination) do
    query =
      from p in Post,
        join: pa  in assoc(p, :author),
        join: pap in assoc(pa, :profile),
        where: [profile_id: ^profile.id],
        order_by: [desc: :id],
        offset: ^pagination.offset,
        limit: ^pagination.limit,
        preload: [
          author: {pa, profile: pap},
          comments: ^comments_query]

    Repo.all(query)
  end

  defp comments_query do
    from c in Comment,
      join: ca  in assoc(c, :author),
      join: cap in assoc(ca, :profile),
      order_by: :id,
      preload: [author: {ca, profile: cap}]
  end
end
