defmodule Art.Canvases.Operations.RectangleTest do
  use ExUnit.Case

  alias Art.Canvases.Operations.Rectangle

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

    test "returns error when fill and outline present" do
      attrs = %{
        start_coordinates: [14, 0],
        width: 7,
        height: 6,
        outline_character: ".",
        fill: "."
      }

      assert {:error, changeset} = Rectangle.build(attrs)
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :outline_character)
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
end
