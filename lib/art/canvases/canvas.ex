defmodule Art.Canvases.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:width, :integer)
    field(:height, :integer)
    field(:points, {:array, :map})
  end

  def build(points, canvas_size) do
    {
      :ok,
      %__MODULE__{
        points: points,
        width: canvas_size["width"],
        height: canvas_size["height"]
      }
    }
  end

  # TODO: in the future it should fetch data from db
  #
  def draw(canvas) do
    grouped_points = canvas.points |> Enum.group_by(& &1.row)

    text =
      for row <- 0..(canvas.height - 1) do
        group = grouped_points[row]

        string_row =
          for col <- 0..(canvas.width - 1) do
            if group do
              Enum.find(group, %{content: " "}, &(&1.column == col)).content
            else
              " "
            end
          end
          |> Enum.join()

        string_row <> "\n"
      end

    Enum.join(text)
  end
end
