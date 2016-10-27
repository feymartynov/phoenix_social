defmodule PhoenixSocial.Queries.Feed do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Friendship, Comment}

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
          p.user_id   == p.author_id)),
      order_by: [desc: p.id],
      group_by: p.id,
      offset: ^pagination.offset,
      limit: ^pagination.limit,
      preload: [
        :author,
        comments: ^comments_query]

    Repo.all(query)
  end

  defp comments_query do
    from c in Comment,
    join: a in assoc(c, :author),
    order_by: :id,
    preload: [author: a]
  end

  # the same logic as in the above SQL where clause
  def belongs_to_feed?(post, user) do
    user.id in [post.author_id, post.user_id] || friends_post?(post, user)
  end

  defp friends_post?(post, user) do
    post.user_id == post.author_id &&
      user.friendships |> Enum.any?(fn friendship ->
        friendship.user2_id == post.author_id &&
          friendship.state == "confirmed"
      end)
  end
end
