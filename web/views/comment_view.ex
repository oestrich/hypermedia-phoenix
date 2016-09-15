defmodule Todos.CommentView do
  use Todos.Web, :view
  import Todos.ApiView

  def render("index.json", %{comments: comments, url: url}) do
    %{items: render_many(comments, Todos.CommentView, "comment.json")}
    |> collection(url)
    |> template("Add Comment")
  end

  def render("show.json", %{comment: comment, url: url}) do
    %{items: [render_one(comment, Todos.CommentView, "comment.json")]}
    |> collection(url)
    |> template("Edit Comment")
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      todo_id: comment.todo_id,
      body: comment.body}
    |> item
  end

  defp item(comment) do
    %{
      href: comment_url(Todos.Endpoint, :show, comment.id),
      data: comment |> collection_data,
      links: comment |> links,
    }
  end

  defp template(collection, template_name) do
    %{
      prompt: template_name,
      rel: "create-form",
      data: [
        %{ name: "body", prompt: "Body" },
      ],
    } |> collection_template(collection)
  end

  defp links(comment) do
    [
      %{ href: todo_url(Todos.Endpoint, :show, comment.todo_id), rel: "http://localhost/todo" },
    ]
  end
end
