defmodule Art.Canvases.Operations.Rectangle do
  use Ecto.Schema
  import Ecto.Changeset
  alias Art.Canvases.Operations.{Behaviours, Point}

  @behaviour Behaviours.Operation

  @allowed_attributes [:start_coordinates, :width, :height, :fill, :outline_character]

  embedded_schema do
    field(:start_coordinates, {:array, :integer})
    field(:width, :integer)
    field(:height, :integer)
    field(:fill, :string)
    field(:outline_character, :string)
  end

  @impl Behaviours.Operation
  def build(attrs) do
    changeset =
      %__MODULE__{}
      |> cast(attrs, @allowed_attributes, empty_values: ["none"])
      |> validate_required([:start_coordinates, :width, :height])
      |> validate_painting_type

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  @impl Behaviours.Operation
  def build_points(%__MODULE__{fill: nil} = rectangle) do
    build_outline_points(
      rectangle.start_coordinates,
      rectangle.width,
      rectangle.height,
      rectangle.outline_character
    )
  end

  def build_points(%__MODULE__{outline_character: nil} = rectangle) do
    build_internal_points(
      rectangle.start_coordinates,
      rectangle.width,
      rectangle.height,
      rectangle.fill
    )
  end

  def build_points(%__MODULE__{} = rectangle) do
    [col, row] = rectangle.start_coordinates

    build_outline_points(
      rectangle.start_coordinates,
      rectangle.width,
      rectangle.height,
      rectangle.outline_character
    ) ++
      build_internal_points(
        [col + 1, row + 1],
        rectangle.width - 2,
        rectangle.height - 2,
        rectangle.fill
      )
  end

  defp build_internal_points(starting_coordinate, width, height, character, res \\ []) do
    [upper_left_col, upper_left_row] = starting_coordinate
    res = res ++ build_outline_points(starting_coordinate, width, height, character)

    if width > 2 && height > 2 do
      build_internal_points(
        [upper_left_col + 1, upper_left_row + 1],
        width - 2,
        height - 2,
        character,
        res
      )
    else
      res
    end
  end

  defp build_outline_points(starting_coordinate, width, height, character)
       when width > 2 and height > 2 do
    [upper_left_col, upper_left_row] = starting_coordinate
    lower_right_col = upper_left_col + width - 1
    lower_right_row = upper_left_row + height - 1

    horizontal_points =
      for column <- upper_left_col..lower_right_col, row <- [upper_left_row, lower_right_row] do
        %Point{column: column, row: row, content: character}
      end

    vertical_points =
      for row <- (upper_left_row + 1)..(lower_right_row - 1),
          column <- [upper_left_col, lower_right_col] do
        %Point{column: column, row: row, content: character}
      end

    horizontal_points ++ vertical_points
  end

  defp build_outline_points(starting_coordinate, width, height, character)
       when width == 1 and height == 1 do
    [column, row] = starting_coordinate

    [%Point{column: column, row: row, content: character}]
  end

  defp build_outline_points(starting_coordinate, width, height, character) do
    [x, y] = starting_coordinate

    for column <- x..(x + width - 1), row <- [y, y + height - 1] do
      %Point{column: column, row: row, content: character}
    end
  end

  defp validate_painting_type(changeset) do
    is_absent = fn field ->
      changeset
      |> get_field(field)
      |> is_nil
    end

    cond do
      is_absent.(:outline_character) ->
        changeset
        |> validate_exclusion(:fill, [])
        |> validate_length(:fill, is: 1)

      is_absent.(:fill) ->
        changeset
        |> validate_exclusion(:outline_character, [])
        |> validate_length(:outline_character, is: 1)

      true ->
        changeset
        |> validate_length(:outline_character, is: 1)
        |> validate_length(:fill, is: 1)
    end
  end
end
