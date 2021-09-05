defmodule Art.Canvases.Operations.Rectangle do
  use Ecto.Schema
  import Ecto.Changeset
  alias Art.Canvases.Operations.Behaviours

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
        add_error(
          changeset,
          :outline_character,
          "one of either fill or outline_character should be present"
        )
    end
  end
end
