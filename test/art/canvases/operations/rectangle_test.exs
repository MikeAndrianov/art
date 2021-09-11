defmodule Art.Canvases.Operations.RectangleTest do
  use ExUnit.Case

  alias Art.Canvases.Operations.{Rectangle, Point}

  describe "build/1" do
    test "returns ok tuple" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "none",
        fill: "."
      }

      assert {:ok, %Rectangle{}} = Rectangle.build(attrs)
    end

    test "returns ok tuple when outline and fill are present" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "@",
        fill: "."
      }

      assert {:ok, %Rectangle{}} = Rectangle.build(attrs)
    end

    test "returns error when fill and outline are present, but with invalid length" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "++",
        fill: "@@"
      }

      assert {:error, changeset} = Rectangle.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :outline_character)
      assert Keyword.has_key?(changeset.errors, :fill)
    end

    test "returns error when fill has invalid length" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "none",
        fill: "12"
      }

      assert {:error, changeset} = Rectangle.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :fill)
    end

    test "returns error when outline_character has invalid length" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "12",
        fill: "none"
      }

      assert {:error, changeset} = Rectangle.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :outline_character)
    end

    test "returns error when outline_character and fill are absent" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: "",
        fill: ""
      }

      assert {:error, changeset} = Rectangle.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :outline_character)
    end
  end

  describe "build_points/1" do
    test "returns all points with fill character" do
      rectangle = %Rectangle{
        id: nil,
        start_coordinates: [1, 1],
        width: 3,
        height: 3,
        outline_character: nil,
        fill: "."
      }

      points = Rectangle.build_points(rectangle)

      assert points == [
               %Point{column: 1, content: ".", row: 1},
               %Point{column: 1, content: ".", row: 3},
               %Point{column: 2, content: ".", row: 1},
               %Point{column: 2, content: ".", row: 3},
               %Point{column: 3, content: ".", row: 1},
               %Point{column: 3, content: ".", row: 3},
               %Point{column: 1, content: ".", row: 2},
               %Point{column: 3, content: ".", row: 2},
               %Point{column: 2, content: ".", row: 2}
             ]
    end

    test "returns points with outline and fill characters" do
      rectangle = %Rectangle{
        id: nil,
        start_coordinates: [1, 1],
        width: 3,
        height: 3,
        outline_character: "@",
        fill: "."
      }

      points = Rectangle.build_points(rectangle)

      assert points == [
               %Point{column: 1, content: "@", row: 1},
               %Point{column: 1, content: "@", row: 3},
               %Point{column: 2, content: "@", row: 1},
               %Point{column: 2, content: "@", row: 3},
               %Point{column: 3, content: "@", row: 1},
               %Point{column: 3, content: "@", row: 3},
               %Point{column: 1, content: "@", row: 2},
               %Point{column: 3, content: "@", row: 2},
               %Point{column: 2, content: ".", row: 2}
             ]
    end

    test "returns points for narrow rectangle" do
      rectangle = %Rectangle{
        id: nil,
        start_coordinates: [1, 1],
        width: 3,
        height: 2,
        outline_character: nil,
        fill: "."
      }

      points = Rectangle.build_points(rectangle)

      assert points == [
               %Point{column: 1, content: ".", row: 1},
               %Point{column: 1, content: ".", row: 2},
               %Point{column: 2, content: ".", row: 1},
               %Point{column: 2, content: ".", row: 2},
               %Point{column: 3, content: ".", row: 1},
               %Point{column: 3, content: ".", row: 2}
             ]
    end
  end
end
