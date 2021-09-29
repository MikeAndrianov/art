defmodule Art.Canvases.Operations.FloodFill do
  use Ecto.Schema
  import Ecto.Changeset
  alias Art.Canvases.Operations.{Behaviours, Point}

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

  def build_points(flood_fill, canvas_size, existing_points \\ %{}) do
    fill(existing_points, flood_fill.start_coordinates, flood_fill.fill_character, canvas_size)
  end

  defp fill(existing_points, coordinate, character, canvas_size) do
    [col, row] = coordinate

    cond do
      col > canvas_size["width"] - 1 || col < 0 || row > canvas_size["height"] - 1 || row < 0 ->
        existing_points

      existing_points[{col, row}] ->
        existing_points

      true ->
        point = %Point{column: col, row: row, content: character}

        existing_points
        |> Map.put({col, row}, point)
        |> fill([col + 1, row], character, canvas_size)
        |> fill([col - 1, row], character, canvas_size)
        |> fill([col, row + 1], character, canvas_size)
        |> fill([col, row - 1], character, canvas_size)
    end
  end
end
