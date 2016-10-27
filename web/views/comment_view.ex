defmodule PhoenixSocial.CommentView do
  alias PhoenixSocial.{Repo, Avatar}

  @fields [:id, :post_id, :text, :inserted_at, :updated_at]
  @author_fields [:id, :first_name, :last_name]

  def render(comment) do
    comment = comment |> Repo.preload(:author)

    comment
    |> Map.take(@fields)
    |> Map.put(:author, render_author(comment.author))
  end

  defp render_author(user) do
    user
    |> Map.take(@author_fields)
    |> Map.put(:avatar, Avatar.public_urls({user.avatar, user}))
  end
end
