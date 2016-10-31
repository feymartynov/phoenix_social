defmodule PhoenixSocial.AuthorView do
  alias PhoenixSocial.{Profile, Avatar}

  def render(profile) do
    profile
    |> Map.take([:first_name, :last_name])
    |> Map.put(:id, profile.user_id)
    |> Map.put(:slug, profile |> Profile.slug)
    |> Map.put(:full_name, profile |> Profile.full_name)
    |> Map.put(:avatar, Avatar.public_urls({profile.avatar, profile}))
  end
end
