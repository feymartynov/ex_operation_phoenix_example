defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug(:accepts, ~w(html))
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :authentication do
    plug(AppWeb.Authenticate)
  end

  # Public
  scope "/", AppWeb do
    pipe_through(:browser)

    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)

    get("/sign-up", UserController, :new)
    post("/sign-up", UserController, :create)
  end

  # Protected
  scope "/", AppWeb do
    pipe_through([:browser, :authentication])

    resources("/posts", PostController) do
      resources("/comments", CommentController, only: [:create, :update, :delete])
    end

    post("/sign-out", SessionController, :delete)
    get("/", PostController, :index)
  end
end
