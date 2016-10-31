defmodule PhoenixSocial.PostView do
  alias PhoenixSocial.{CommentView, AuthorView}

  @fields [:id, :profile_id, :text, :inserted_at, :updated_at]

  def render(post) do
    post
    |> Map.take(@fields)
    |> Map.put(:author, post.author |> AuthorView.render)
    |> Map.put(:comments, Enum.map(post.comments, &CommentView.render/1))
  end
end
