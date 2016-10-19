defmodule PhoenixSocial.Router do
  use PhoenixSocial.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api", PhoenixSocial do
    pipe_through :api

    scope "/v1" do
      resources "/session", SessionController, only: [:show, :create, :delete], singleton: true
      resources "/friends", FriendController, only: [:create, :delete]
      resources "/avatar", AvatarController, only: [:create, :delete], singleton: true
      resources "/posts", PostController, only: [:update, :delete]

      resources "/users", UserController, only: [:create, :show, :update] do
        resources "/posts", PostController, only: [:index, :create]
      end
    end
  end

  scope "/", PhoenixSocial do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
