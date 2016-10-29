Code.require_file("#{__DIR__}/factory.ex")
Code.require_file("#{__DIR__}/api_call.ex")
Code.require_file("#{__DIR__}/../integration/steps/global.ex")

defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias PhoenixSocial.Repo
      import PhoenixSocial.Factory
    end
  end

  def controller do
    quote do
      alias PhoenixSocial.Repo
      import PhoenixSocial.Router.Helpers
      import PhoenixSocial.Factory
      import PhoenixSocial.Support.ApiCall

      @endpoint PhoenixSocial.Endpoint
    end
  end

  def channel do
    quote do
      alias PhoenixSocial.Repo
      import PhoenixSocial.Factory

      @endpoint PhoenixSocial.Endpoint
    end
  end

  def integration do
    quote do
      use ESpec
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import PhoenixSocial.Router.Helpers
      import PhoenixSocial.Factory
      import PhoenixSocial.Integration.Steps.Global

      alias PhoenixSocial.Repo

      @endpoint PhoenixSocial.Endpoint

      before do
        Hound.start_session
        current_window_handle |> set_window_size(1280, 1024)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
