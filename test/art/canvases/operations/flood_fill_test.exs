defmodule Art.Canvases.Operations.FloodFillTest do
  use ExUnit.Case

  alias Art.Canvases.Operations.FloodFill

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

      assert {:error, changeset} = FloodFill.build(%{})
      refute changeset.valid?
      assert Keyword.has_key?(changeset.errors, :fill_character)
    end
  end
end
