defmodule Art.Canvases.Operations.Behaviours.Operation do
  @doc """
  Builds a struct from given attributes.
  """
  @callback build(map) :: {:ok, struct} | {:error, struct}
end
