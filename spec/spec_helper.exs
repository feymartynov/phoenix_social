{:ok, _} = Application.ensure_all_started(:hound)
{:ok, _} = Application.ensure_all_started(:ex_machina)

Ecto.Adapters.SQL.Sandbox.mode(PhoenixSocial.Repo, :manual)

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PhoenixSocial.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixSocial.Repo, {:shared, self()})
    end
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(PhoenixSocial.Repo, [])
  end
end
