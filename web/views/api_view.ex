defmodule Todos.ApiView do
  def collection(%{items: items}, url) do
    %{
      collection: %{
        version: "1.0",
        href: url,
        items: items,
      },
    }
  end

  def collection_data(todo) do
    Enum.reduce(todo, [], fn({key, value}, data) ->
      [%{name: key, value: value, prompt: key} | data]
    end)
  end

  def collection_template(template, %{collection: collection}) do
    %{
      collection: Map.put(collection, :template, template)
    }
  end
end
