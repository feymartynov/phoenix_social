defmodule PhoenixSocial.PostView do
  alias PhoenixSocial.{CommentView, AuthorView}

  @fields [:id, :user_id, :text, :inserted_at, :updated_at]

  def render(post) do
    post
    |> Map.take(@fields)
    |> Map.put(:author, post.author.profile |> AuthorView.render)
    |> Map.put(:comments, Enum.map(post.comments, &CommentView.render/1))
  end
end
