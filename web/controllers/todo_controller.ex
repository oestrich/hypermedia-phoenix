defmodule Todos.TodoController do
  use Todos.Web, :controller
  import Todos.ApiController

  alias Todos.Todo

  def index(conn, _params) do
    todos = Repo.all(from t in Todo, order_by: [asc: t.inserted_at])
    render(conn, "index.json", todos: todos, url: todo_url(Todos.Endpoint, :index))
  end

  def create(conn, %{"template" => %{ "data" => todo_params }}) do
    changeset = Todo.changeset(%Todo{}, template_data(todo_params))

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", todo_path(conn, :show, todo))
        |> render("show.json", todo: todo, url: todo_url(Todos.Endpoint, :show, todo.id))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todos.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    render(conn, "show.json", todo: todo, url: todo_url(Todos.Endpoint, :show, id))
  end

  def update(conn, %{"id" => id, "template" => %{ "data" => todo_params }}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, template_data(todo_params))

    case Repo.update(changeset) do
      {:ok, todo} ->
        render(conn, "show.json", todo: todo, url: todo_url(Todos.Endpoint, :show, todo.id))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todos.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    Repo.delete!(todo)

    # TODO I think this should be a 204
    # send_resp(conn, :no_content, "")
    todos = Repo.all(Todo)
    render(conn, "index.json", todos: todos, url: todo_url(Todos.Endpoint, :index))
  end
end
