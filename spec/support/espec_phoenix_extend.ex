Code.require_file("#{__DIR__}/api_call.ex")

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

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
