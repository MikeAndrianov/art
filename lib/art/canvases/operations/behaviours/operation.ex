defmodule Art.Canvases.Operations.Behaviours.Operation do
  @doc """
  Builds a struct from given attributes.
  """
  @callback build(map) :: {:ok, struct} | {:error, struct}

  @doc """
  Builds a list of points with character.
  """
  @callback build_points(map, list, map) :: [struct]
end
