{:ok, _} = Application.ensure_all_started(:hound)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start
