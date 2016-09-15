defmodule Todos.TodoView do
  use Todos.Web, :view

  defp collection(%{items: items}, url) do
    %{
      collection: %{
        version: "1.0",
        href: url,
        items: items,
      },
    }
  end

  defp item(todo) do
    %{
      href: todo_url(Todos.Endpoint, :show, todo.id),
      data: todo |> data,
    }
  end

  defp data(todo) do
    Enum.reduce(todo, [], fn({key, value}, data) ->
      [%{name: key, value: value, prompt: key} | data]
    end)
  end

  defp template(%{collection: collection}, template_name) do
    template = %{
      prompt: template_name,
      rel: "create-form",
      data: [
        %{ name: "title", prompt: "Title" },
        %{ name: "completed", prompt: "Completed", value: "false" },
      ]
    }

    %{
      collection: Map.put(collection, :template, template)
    }
  end

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
end
