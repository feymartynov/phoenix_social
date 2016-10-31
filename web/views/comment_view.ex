defmodule PhoenixSocial.CommentView do
  alias PhoenixSocial.AuthorView

  @fields [:id, :post_id, :text, :inserted_at, :updated_at]

  def render(comment) do
    comment
    |> Map.take(@fields)
    |> Map.put(:author, comment.author.profile |> AuthorView.render)
  end
end
