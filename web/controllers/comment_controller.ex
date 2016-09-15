defmodule Todos.CommentController do
  use Todos.Web, :controller
  import Todos.ApiController

  alias Todos.Todo
  alias Todos.Comment

  def index(conn, %{"todo_id" => todo_id}) do
    todo = Repo.get(Todo, todo_id)
    comments = Repo.all(assoc(todo, :comments))
    render(conn, "index.json", comments: comments, url: todo_comment_url(conn, :index, todo_id))
  end

  def create(conn, %{"template" => %{ "data" => comment_params }}) do
    changeset = Comment.changeset(%Comment{}, template_data(comment_params))

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_url(conn, :show, comment))
        |> render("show.json", comment: comment, url: comment_url(conn, :show, comment.id))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todos.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => comment_id}) do
    comment = Repo.get(Comment, comment_id)
    render(conn, "show.json", comment: comment, url: comment_url(conn, :show, comment_id))
  end

  def update(conn, %{"id" => id, "template" => %{ "data" => comment_params }}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, template_data(comment_params))

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", comment: comment, url: comment_url(conn, :show, comment.id))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Comments.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    Repo.delete!(comment)

    comments = Repo.all(Comment)
    render(conn, "index.json", comments: comments, url: todo_comment_url(conn, :index, comment.todo_id))
  end
end
