defmodule PhoenixSocial.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use PhoenixSocial.Web, :controller
      use PhoenixSocial.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      use Timex.Ecto.Timestamps

      def error_messages(changeset) do
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(msg, "%{#{key}}", to_string(value))
          end)
        end)
      end
    end
  end

  def params do
    quote do
      import Plug.Conn
      use PhoenixSocial.Web, :model
      use Phoenix.Controller

      def init(options), do: options

      def call(conn, key) do
        changeset = __MODULE__.changeset(struct(__MODULE__), conn.params)

        if changeset.valid? do
          validated_params = Map.merge(struct(__MODULE__), changeset.changes)
          conn |> assign(key, validated_params)
        else
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: __MODULE__.error_messages(changeset)})
          |> halt
        end
      end
    end
  end

  def query do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Query

      use Timex.Ecto.Timestamps

      alias PhoenixSocial.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias PhoenixSocial.Repo
      import Ecto
      import Ecto.Query

      import PhoenixSocial.Router.Helpers
      import PhoenixSocial.Gettext

      plug :set_current_user

      defp set_current_user(conn, _params) do
        assign(conn, :current_user, Guardian.Plug.current_resource(conn))
      end

      defp respond_with_error(conn, error) do
        conn |> put_status(:unprocessable_entity) |> json(%{error: error})
      end
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PhoenixSocial.Router.Helpers
      import PhoenixSocial.ErrorHelpers
      import PhoenixSocial.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias PhoenixSocial.Repo
      import Ecto
      import Ecto.Query
      import PhoenixSocial.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
