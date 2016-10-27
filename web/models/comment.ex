defmodule PhoenixSocial.Comment do
  use PhoenixSocial.Web, :model

  schema "comments" do
    field :text, :string
    timestamps
    belongs_to :author, PhoenixSocial.User
    belongs_to :post, PhoenixSocial.Post
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
