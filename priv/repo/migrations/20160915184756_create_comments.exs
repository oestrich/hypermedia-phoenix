defmodule Todos.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :todo_id, references(:todos)
      add :body, :string

      timestamps()
    end
  end
end
