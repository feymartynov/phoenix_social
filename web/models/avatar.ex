defmodule PhoenixSocial.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:big]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def __storage, do: Arc.Storage.Local

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:big, _) do
    im_options = """
      -thumbnail 200x300^ -gravity center -extent 200x300 -format jpg
    """

    {:convert, im_options, :jpg}
  end

  def filename(version, {_file, user}) do
    "user#{user.id}_#{version}"
  end

  def storage_dir(_version, {_file, user}) do
    "priv/static/uploads/avatars/user#{user.id}"
  end
end
