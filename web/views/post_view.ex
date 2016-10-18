defmodule PhoenixSocial.PostView do
  @fields [:id, :user_id, :text, :inserted_at, :updated_at]

  def render(post) do
    post |> Map.take(@fields)
  end
end
