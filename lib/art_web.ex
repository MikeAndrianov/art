defmodule ArtWeb do
  alias ArtWeb.Renderer

  def renderer do
    quote do
      import Renderer
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
