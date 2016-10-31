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
      resources "/users", UserController, only: [:create, :show]
      resources "/friends", FriendController, only: [:create, :delete]
      resources "/comments", CommentController, only: [:update, :delete]
      resources "/feed", FeedController, only: [:show], singleton: true

      resources "/profiles", ProfileController, only: [:show, :update] do
        resources "/avatar", AvatarController, only: [:create, :delete], singleton: true
        resources "/posts", PostController, only: [:index, :create]
      end

      resources "/posts", PostController, only: [:update, :delete] do
        resources "/comments", CommentController, only: [:create]
      end
    end
  end

  scope "/", PhoenixSocial do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
