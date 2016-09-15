defmodule Todos.Router do
  use Todos.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["collection+json", "json"]
  end

  scope "/", Todos do
    pipe_through :api
    resources "/comments", CommentController, only: [:show, :update, :delete]

    resources "/todos", TodoController, only: [:show, :update, :delete] do
      resources "/comments", CommentController, only: [:index, :create]
    end

    resources "/", TodoController, only: [:index, :create]
  end

  scope "/", Todos do
    pipe_through :browser # Use the default browser stack
  end

  # Other scopes may use custom stacks.
  # scope "/api", Todos do
  #   pipe_through :api
  # end
end
