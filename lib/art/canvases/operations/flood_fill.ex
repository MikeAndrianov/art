defmodule Art.Canvases.Operations.FloodFill do
  use Ecto.Schema
  import Ecto.Changeset
  alias Art.Canvases.Operations.Behaviours

  @behaviour Behaviours.Operation

  embedded_schema do
    field(:start_coordinates, {:array, :integer})
    field(:fill_character, :string)
  end

  @impl Behaviours.Operation
  def build(attrs) do
    changeset =
      %__MODULE__{}
      |> cast(attrs, [:start_coordinates, :fill_character])
      |> validate_required([:start_coordinates, :fill_character])
      |> validate_length(:fill_character, is: 1)


    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
