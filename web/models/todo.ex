defmodule Todos.Todo do
  use Todos.Web, :model

  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false

    has_many :comments, Todos.Comment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :completed])
    |> validate_required([:title, :completed])
  end
end
