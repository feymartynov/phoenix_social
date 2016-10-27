defmodule PhoenixSocial.Queries.Wall do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Comment}

  def posts(user, pagination) do
    query =
      from p in Post,
        join: a in assoc(p, :author),
        where: [user_id: ^user.id],
        order_by: [desc: :id],
        offset: ^pagination.offset,
        limit: ^pagination.limit,
        preload: [
          author: a,
          comments: ^comments_query]

    Repo.all(query)
  end

  defp comments_query do
    from c in Comment,
      join: a in assoc(c, :author),
      order_by: :id,
      preload: [author: a]
  end
end
