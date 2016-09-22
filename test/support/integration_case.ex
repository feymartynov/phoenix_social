defmodule PhoenixSocial.IntegrationCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import PhoenixSocial.Router.Helpers
      import PhoenixSocial.Factory
      import PhoenixSocial.IntegrationCase

      alias PhoenixSocial.Repo

      @endpoint PhoenixSocial.Endpoint

      hound_session
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.checkout(PhoenixSocial.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixSocial.Repo, {:shared, self()})
    end

    Hound.start_session
    current_window_handle() |> set_window_size(1280, 1024)

    :ok
  end

  def sign_in(user) do
    navigate_to "/"

    script = ~s"""
      localStorage.setItem('phoenixSocialAuthToken', arguments[0]);
    """

    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
    execute_script(script, [jwt])
    user
  end
end
