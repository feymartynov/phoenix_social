defmodule PhoenixSocial.Operations.CreatePost do
  alias PhoenixSocial.{Repo, Post}
  import PhoenixSocial.Friendship, only: [friend_of?: 2]

  def call(user, author, text) do
    post = %Post{user: user, author: author}
    changeset = Post.changeset(post, %{text: text})

    if authorized?(user, author) do
      Repo.insert(changeset)
    else
      user = user |> Repo.preload(:profile)
      error = "is not a friend of #{user.profile}"
      {:error, changeset |> Ecto.Changeset.add_error(:author, error)}
    end
  end

  defp authorized?(user, author) do
    user.id == author.id || author |> friend_of?(user)
  end
end
