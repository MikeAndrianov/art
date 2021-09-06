defmodule Art.Canvases.OperationTest do
  use ExUnit.Case
  doctest Art.Canvases.Operation

  alias Art.Canvases.Operation
  alias Art.Canvases.Operations.{FloodFill, Rectangle}

  describe "build/1" do
    test "with rectangle operation type returns rectangle struct" do
      operation_string =
        "Rectangle at [14, 0] with width 7, height 6, outline character: none, fill: ."

      {:ok, operation} = Operation.build(operation_string)

      assert %Rectangle{
               start_coordinates: [14, 0],
               width: 7,
               height: 6,
               outline_character: nil,
               fill: "."
             } = operation
    end

    test "parses correctly regardless of parameters order" do
      operation_string =
        "Rectangle at [123,456] with    height 6,width 7,outline character: *, fill: none"

      {:ok, operation} = Operation.build(operation_string)

      assert %Rectangle{
               start_coordinates: [123, 456],
               width: 7,
               height: 6,
               outline_character: "*",
               fill: nil
             } = operation
    end

    test "with flood fill operation type returns flood fill struct" do
      operation_string = "Flood fill at [1, 2] with fill character -"
      {:ok, operation} = Operation.build(operation_string)

      assert %FloodFill{
               start_coordinates: [1, 2],
               fill_character: "-"
             } = operation
    end

    test "returns error when operation type is invalid" do
      operation_string =
        "Circle at [123,456] with width 7, height 6, outline character: none, fill: ."

      assert Operation.build(operation_string) == {:error, "Operation type is not valid"}
    end
  end
end
