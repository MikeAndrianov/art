defmodule Art.Canvases.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :content, :inserted_at, :updated_at]}
  schema "canvases" do
    field(:content, :string)
    field(:width, :integer, virtual: true)
    field(:height, :integer, virtual: true)
    field(:points, {:array, :map}, virtual: true)

    timestamps()
  end

  def changeset(canvas, attrs \\ %{}) do
    canvas
    |> cast(attrs, [:points, :width, :height])
    |> validate_required([:points, :width, :height])
    |> put_content
  end

  defp put_content(changeset) do
    grouped_points =
      changeset
      |> Ecto.Changeset.get_change(:points)
      |> Enum.group_by(& &1.row)

    width = Ecto.Changeset.get_change(changeset, :width) - 1
    height = Ecto.Changeset.get_change(changeset, :height) - 1

    text_rows =
      for row <- 0..height do
        group = grouped_points[row]

        string_row =
          for col <- 0..width do
            if group do
              Enum.find(group, %{content: " "}, &(&1.column == col)).content
            else
              " "
            end
          end
          |> Enum.join()

        string_row <> "\n"
      end

    Ecto.Changeset.put_change(changeset, :content, Enum.join(text_rows))
  end
end
