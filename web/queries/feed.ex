defmodule PhoenixSocial.Queries.Feed do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Friendship}

  def posts(user, pagination) do
    query =
      from p in Post,
      left_join: f in Friendship,
      where:
        p.inserted_at >= ^(Timex.now |> Timex.shift(days: -7)) and
       (p.author_id   == ^user.id or     # all my posts +
        p.user_id     == ^user.id or     # all posts on my wall +
         (p.author_id == f.user2_id  and # friends' posts on their walls
          f.state     == "confirmed" and
          f.user1_id  == ^user.id    and
          p.user_id   == f.user2_id)),
      order_by: [desc: p.id],
      group_by: p.id,
      offset: ^pagination.offset,
      limit: ^pagination.limit,
      preload: [:author]

    Repo.all(query)
  end
end
