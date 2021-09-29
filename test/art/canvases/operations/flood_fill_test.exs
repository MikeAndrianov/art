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

      assert points == %{
               {0, 0} => %Art.Canvases.Operations.Point{column: 0, content: "@", row: 0},
               {0, 1} => %Art.Canvases.Operations.Point{column: 0, content: "@", row: 1},
               {0, 2} => %Art.Canvases.Operations.Point{column: 0, content: "@", row: 2},
               {0, 3} => %Art.Canvases.Operations.Point{column: 0, content: "@", row: 3},
               {0, 4} => %Art.Canvases.Operations.Point{column: 0, content: "@", row: 4},
               {1, 0} => %Art.Canvases.Operations.Point{column: 1, content: "@", row: 0},
               {1, 1} => %Art.Canvases.Operations.Point{column: 1, content: ".", row: 1},
               {1, 2} => %Art.Canvases.Operations.Point{column: 1, content: ".", row: 2},
               {1, 3} => %Art.Canvases.Operations.Point{column: 1, content: ".", row: 3},
               {1, 4} => %Art.Canvases.Operations.Point{column: 1, content: "@", row: 4},
               {2, 0} => %Art.Canvases.Operations.Point{column: 2, content: "@", row: 0},
               {2, 1} => %Art.Canvases.Operations.Point{column: 2, content: ".", row: 1},
               {2, 3} => %Art.Canvases.Operations.Point{column: 2, content: ".", row: 3},
               {2, 4} => %Art.Canvases.Operations.Point{column: 2, content: "@", row: 4},
               {3, 0} => %Art.Canvases.Operations.Point{column: 3, content: "@", row: 0},
               {3, 1} => %Art.Canvases.Operations.Point{column: 3, content: ".", row: 1},
               {3, 2} => %Art.Canvases.Operations.Point{column: 3, content: ".", row: 2},
               {3, 3} => %Art.Canvases.Operations.Point{column: 3, content: ".", row: 3},
               {3, 4} => %Art.Canvases.Operations.Point{column: 3, content: "@", row: 4},
               {4, 0} => %Art.Canvases.Operations.Point{column: 4, content: "@", row: 0},
               {4, 1} => %Art.Canvases.Operations.Point{column: 4, content: "@", row: 1},
               {4, 2} => %Art.Canvases.Operations.Point{column: 4, content: "@", row: 2},
               {4, 3} => %Art.Canvases.Operations.Point{column: 4, content: "@", row: 3},
               {4, 4} => %Art.Canvases.Operations.Point{column: 4, content: "@", row: 4}
             }
    end
  end
end
