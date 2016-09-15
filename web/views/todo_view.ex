defmodule Todos.TodoView do
  use Todos.Web, :view
  import Todos.ApiView

  def render("index.json", %{todos: todos, url: url}) do
    %{items: render_many(todos, Todos.TodoView, "todo.json")}
    |> collection(url)
    |> template("Add ToDo")
  end

  def render("show.json", %{todo: todo, url: url}) do
    %{items: [render_one(todo, Todos.TodoView, "todo.json")]}
    |> collection(url)
    |> template("Edit ToDo")
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      title: todo.title,
      completed: todo.completed}
    |> item
  end

  defp item(todo) do
    %{
      href: todo_url(Todos.Endpoint, :show, todo.id),
      data: todo |> collection_data,
      links: todo |> links,
    }
  end

  defp template(collection, template_name) do
    %{
      prompt: template_name,
      rel: "create-form",
      data: [
        %{ name: "title", prompt: "Title" },
        %{ name: "completed", prompt: "Completed", value: "false" },
      ],
    } |> collection_template(collection)
  end

  defp links(todo) do
    [
      %{ href: todo_comment_url(Todos.Endpoint, :index, todo.id), rel: "http://localhost/comments" },
    ]
  end
end
