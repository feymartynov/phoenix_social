defmodule PhoenixSocial.Operations.CreatePost do
  alias PhoenixSocial.{Repo, Post}
  import PhoenixSocial.Friendship, only: [friend_of?: 2]

  def call(profile, author, text) do
    user = profile |> Repo.preload(:user) |> Map.fetch!(:user)
    post = %Post{profile: profile, author: author}
    changeset = Post.changeset(post, %{text: text})

    if authorized?(user, author) do
      Repo.insert(changeset)
    else
      error = "is not a friend of #{profile}"
      {:error, changeset |> Ecto.Changeset.add_error(:author, error)}
    end
  end

  defp authorized?(user, author) do
    user.id == author.id || author |> friend_of?(user)
  end
end
