defmodule PhoenixSocial.Operations.CreatePost do
  alias PhoenixSocial.{Repo, Post, FeedChannel}
  import PhoenixSocial.Friendship, only: [friend_of?: 2]

  def call(user, author, text) do
    post = %Post{user: user, author: author}
    changeset = Post.changeset(post, %{text: text})

    if authorized?(user, author) do
      save_and_notify(changeset)
    else
      error = "is not a friend of #{user}"
      {:error, changeset |> Ecto.Changeset.add_error(:author, error)}
    end
  end

  defp authorized?(user, author) do
    user.id == author.id || author |> friend_of?(user)
  end

  defp save_and_notify(changeset) do
    case Repo.insert(changeset) do
      {:ok, post} ->
        FeedChannel.notify(post, "added")
        {:ok, post}
      error ->
        error
    end
  end
end
