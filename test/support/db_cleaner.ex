defmodule DbCleaner do
  defmacro __using__(_) do
    quote do
      setup do
        Ecto.Adapters.SQL.Sandbox.checkout(Art.Repo)
      end
    end
  end
end
