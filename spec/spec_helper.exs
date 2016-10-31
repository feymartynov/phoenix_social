alias Ecto.Adapters.SQL.Sandbox
alias PhoenixSocial.Repo

Sandbox.mode(Repo, :manual)

{:ok, _} = Application.ensure_all_started(:hound)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end
  end

  config.finally fn(_shared) ->
    Sandbox.checkin(Repo, [])
  end
end
