defmodule Todos.Comment do
  use Todos.Web, :model

  schema "comments" do
    belongs_to :todo, Todos.Todo
    field :body, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :todo_id])
    |> validate_required([:body])
  end
end
