defmodule PhoenixSocial.PostView do
  alias PhoenixSocial.{Avatar, CommentView}

  @fields [:id, :user_id, :text, :inserted_at, :updated_at]
  @author_fields [:id, :first_name, :last_name]

  def render(post) do
    post
    |> Map.take(@fields)
    |> Map.put(:author, render_author(post.author))
    |> set_comments(render_comments(post.comments))
  end

  defp render_author(user) do
    user
    |> Map.take(@author_fields)
    |> Map.put(:avatar, Avatar.public_urls({user.avatar, user}))
  end

  defp render_comments(comments) do
    Ecto.assoc_loaded?(comments) && Enum.map(comments, &CommentView.render/1)
  end

  defp set_comments(post, false), do: post
  defp set_comments(post, comments), do: Map.put(post, :comments, comments)
end
