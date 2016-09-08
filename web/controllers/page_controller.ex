defmodule PhoenixSocial.PageController do
  use PhoenixSocial.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
