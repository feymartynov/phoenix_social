defmodule PhoenixSocial.Integration.Steps.Global do
  use Hound.Helpers

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
