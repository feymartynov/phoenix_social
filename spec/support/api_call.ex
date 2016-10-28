defmodule PhoenixSocial.Support.ApiCall do
  use Phoenix.ConnTest

  @endpoint PhoenixSocial.Endpoint

  def api_call(method, path, opts \\ []) do
    %{body: body, as: user} = Enum.into(opts, %{body: nil, as: nil})

    path = "/api/v1" <> path
    {conn, body} = put_json_body(build_conn, body)
    conn = conn |> put_auth_header(user)
    response = _api_call(method, conn, path, body)
    response_body = Poison.decode!(response.resp_body)
    {response.status, response_body}
  end

  defp put_json_body(conn, body) when is_map(body) do
    {put_req_header(conn, "content-type", "application/json"),
     Poison.encode!(body)}
  end
  defp put_json_body(conn, body), do: {conn, body}

  defp put_auth_header(conn, nil), do: conn
  defp put_auth_header(conn, user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
    put_req_header(conn, "authorization", jwt)
  end

  defp _api_call(:get, conn, path, _), do: get(conn, path)
  defp _api_call(:post, conn, path, body), do: post(conn, path, body)
  defp _api_call(:put, conn, path, body), do: put(conn, path, body)
  defp _api_call(:delete, conn, path, _), do: delete(conn, path)
end
