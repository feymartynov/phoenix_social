defmodule PhoenixSocial.PostView do
  alias PhoenixSocial.{Repo, Avatar}

  @fields [:id, :user_id, :text, :inserted_at, :updated_at]
  @author_fields [:id, :first_name, :last_name]

  def render(post) do
    post = post |> Repo.preload(:author)

    post
    |> Map.take(@fields)
    |> Map.put(:author, render_author(post.author))
  end

  defp render_author(user) do
    user
    |> Map.take(@author_fields)
    |> Map.put(:avatar, Avatar.public_urls({user.avatar, user}))
  end
end
