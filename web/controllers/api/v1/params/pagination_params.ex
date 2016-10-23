defmodule PhoenixSocial.Params.Pagination do
  use PhoenixSocial.Web, :params

  embedded_schema do
    field :offset, :integer, default: 0
    field :limit, :integer, default: 100
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:offset, :limit])
    |> validate_number(:offset, greater_than_or_equal_to: 0)
    |> validate_number(:limit, greater_than_or_equal_to: 1)
    |> validate_number(:limit, less_than_or_equal_to: 100)
  end
end
