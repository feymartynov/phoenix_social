defmodule PhoenixSocial.SharedPlugs do
  defmacro __using__(_) do
    quote do
      defp find_user(conn, _) do
        id = conn.params["user_id"] || conn.params["id"]

        cond do
          id == "current" ->
            conn |> assign(:user, conn.assigns[:current_user])
          user = PhoenixSocial.Repo.get(PhoenixSocial.User, id) ->
            conn |> assign(:user, user)
          true ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "User not found"})
            |> halt
        end
      end
    end
  end
end
