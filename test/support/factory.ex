defmodule Art.Factory do
  alias Art.Repo
  alias Art.Canvases.Canvas

  def build(:canvas) do
    %Canvas{
      content: "--\n--\n"
    }
  end

  def build(factory_name, attributes) do
    factory_name
    |> build()
    |> struct(attributes)
  end

  def insert(key) when is_atom(key) do
    key
    |> build
    |> insert
  end

  def insert(struct), do: Art.Repo.insert(struct)
end
