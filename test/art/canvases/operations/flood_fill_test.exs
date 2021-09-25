defmodule Art.Canvases.Operations.FloodFillTest do
  use ExUnit.Case

  alias Art.Canvases.Operations.{FloodFill, Rectangle, Point}

  describe "build/1" do
    test "returns ok tuple" do
      attrs = %{
        start_coordinates: [0, 0],
        fill_character: "-"
      }

      assert {:ok, %FloodFill{}} = FloodFill.build(attrs)
    end

    test "returns error when fields are absent" do
      assert {:error, changeset} = FloodFill.build(%{})
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :start_coordinates)
      assert Keyword.has_key?(changeset.errors, :fill_character)
    end

    test "returns error when fill_character has invalid length" do
      attrs = %{
        start_coordinates: [0, 0],
        fill_character: "-+"
      }

      assert {:error, changeset} = FloodFill.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :fill_character)
    end
  end

  describe "build_points/1" do
    test "fills non-filled points on canvas" do
      existing_points =
        %Rectangle{
          start_coordinates: [1, 1],
          width: 3,
          height: 3,
          outline_character: ".",
          fill: nil
        }
        |> Rectangle.build_points()

      canvas_size = %{"height" => 5, "width" => 5}
      flood_fill = %FloodFill{start_coordinates: [4, 4], fill_character: "@"}

      points = FloodFill.build_points(flood_fill, canvas_size, existing_points)

      assert points == [
               %Point{column: 4, content: "@", row: 3},
               %Point{column: 4, content: "@", row: 2},
               %Point{column: 4, content: "@", row: 1},
               %Point{column: 4, content: "@", row: 0},
               %Point{column: 3, content: "@", row: 0},
               %Point{column: 2, content: "@", row: 0},
               %Point{column: 1, content: "@", row: 0},
               %Point{column: 0, content: "@", row: 0},
               %Point{column: 0, content: "@", row: 1},
               %Point{column: 0, content: "@", row: 2},
               %Point{column: 0, content: "@", row: 3},
               %Point{column: 0, content: "@", row: 4},
               %Point{column: 1, content: "@", row: 4},
               %Point{column: 2, content: "@", row: 4},
               %Point{column: 3, content: "@", row: 4},
               %Point{column: 4, content: "@", row: 4},
               %Point{column: 1, content: ".", row: 1},
               %Point{column: 1, content: ".", row: 3},
               %Point{column: 2, content: ".", row: 1},
               %Point{column: 2, content: ".", row: 3},
               %Point{column: 3, content: ".", row: 1},
               %Point{column: 3, content: ".", row: 3},
               %Point{column: 1, content: ".", row: 2},
               %Point{column: 3, content: ".", row: 2}
             ]
    end
  end
end
