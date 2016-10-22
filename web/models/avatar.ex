defmodule PhoenixSocial.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:big, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @static_root "priv/static"

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
  def transform(:medium, _) do
    im_options = """
      -thumbnail 80x80^ -gravity center -extent 80x80 -format jpg
    """

    {:convert, im_options, :jpg}
  end
  def transform(:thumb, _) do
    im_options = """
      -thumbnail 50x50^ -gravity center -extent 50x50 -format jpg
    """

    {:convert, im_options, :jpg}
  end

  def filename(version, {_file, scope}) do
    "#{scope_name(scope)}#{scope.id}_#{version}"
  end

  def storage_dir(_version, {_file, scope}) do
    Path.join(@static_root, path(scope))
  end

  def public_urls({nil, _}), do: nil
  def public_urls({%{file_name: file}, scope}) do
    Enum.into @versions, %{}, fn(version) ->
      ext = ~r"\.[^\.]*$" |> Regex.scan(file) |> List.first |> List.first
      version_filename = filename(version, {file, scope}) <> ext
      {version, "/" <> Path.join(path(scope), version_filename)}
    end
  end

  defp path(scope) do
    "uploads/avatars/#{scope_name(scope)}#{scope.id}"
  end

  # Elixir.PhoenixSocial.User -> "user"
  defp scope_name(%{__struct__: module}) do
    module |> to_string |> String.split(".") |> List.last |> String.downcase
  end
end
