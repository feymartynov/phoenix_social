defmodule PhoenixSocial.Queries.Wall do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post}

  def posts(user, pagination) do
    query =
      from Post,
        where: [user_id: ^user.id],
        order_by: [desc: :id],
        offset: ^pagination.offset,
        limit: ^pagination.limit,
        preload: [:author]

    Repo.all(query)
  end
end
