defmodule PhoenixSocial.Queries.Feed do
  use PhoenixSocial.Web, :query

  alias PhoenixSocial.{Post, Profile, Friendship, Comment}

  def posts(user, pagination) do
    time = Timex.now |> Timex.shift(days: -7)

    query =
      from p in Post,
        join: pr in Profile,
        left_join: f in Friendship,
        left_join: fpr in Profile,
        where:
          pr.user_id     == ^user.id    and
          p.inserted_at  >= ^time       and
         (p.author_id    == ^user.id    or  # all my posts +
          p.profile_id   == pr.id       or  # all posts on my wall +
           (p.author_id  == f.user2_id  and # friends' posts on their walls
            fpr.user_id  == f.user2_id  and
            p.profile_id == fpr.id      and
            f.user1_id   == ^user.id    and
            f.state      == "confirmed")),
        order_by: [desc: p.id],
        group_by: p.id,
        offset: ^pagination.offset,
        limit: ^pagination.limit,
        preload: [
          author: :profile,
          comments: ^comments_query]

    Repo.all(query)
  end

  defp comments_query do
    from c in Comment,
      order_by: :id,
      preload: [author: :profile]
  end

  # the same logic as in the above SQL where clause
  def belongs_to_feed?(post, user) do
    user.profile.user_id == post.author_id ||
    user.profile.id == post.profile_id ||
    friends_post?(post, user)
  end

  defp friends_post?(post, user) do
    post.profile_id == post.author.profile.id &&
      user.friendships |> Enum.any?(fn friendship ->
        friendship.user2_id == post.author_id &&
          friendship.state == "confirmed"
      end)
  end
end
