defmodule Todos.ApiController do
  def template_data(params) do
    Enum.reduce(params, %{}, fn(datum, map) ->
      Map.put(map, datum["name"], datum["value"])
    end)
  end
end
