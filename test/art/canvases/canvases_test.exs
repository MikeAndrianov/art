defmodule Art.Canvases.CanvasesTest do
  use ExUnit.Case
  use DbCleaner
  import Art.Factory
  alias Art.Canvases
  alias Art.Canvases.Canvas

  describe "get_canvas/1" do
    test "returns canvas" do
      {:ok, canvas} = insert(:canvas)

      found_canvas = Canvases.get_canvas(canvas.id)
      assert found_canvas == canvas
    end

    test "returns nothing when canvas is not found" do
      assert is_nil(Canvases.get_canvas(1))
    end
  end

  describe "list_canvases/0" do
    test "returns all canvases" do
      insert(:canvas)
      insert(:canvas)

      assert length(Canvases.list_canvases()) == 2
    end

    test "returns empty list unless canvases are present" do
      assert Canvases.list_canvases() == []
    end
  end

  describe "create_canvas/2" do
    setup(context) do
      file = %Plug.Upload{
        filename: context.filename,
        path: "test/fixtures/canvases/#{context.filename}"
      }

      %{upload: file}
    end

    @tag filename: "rectangles_1.txt"
    test "creates canvas when data is valid", %{upload: file} do
      size = %{"width" => 32, "height" => 12}

      assert {:ok, %Canvas{}} = Canvases.create_canvas(file, size)
    end

    @tag filename: "rectangles_1.txt"
    test "returns error when canvas size is invalid", %{upload: file} do
      size = %{"width" => -32, "height" => 12}

      assert {:error, "Invalid canvas size"} = Canvases.create_canvas(file, size)
    end

    @tag filename: "rectangles_error.txt"
    test "returns validation errors when data is not valid", %{upload: file} do
      size = %{"width" => 32, "height" => 12}

      assert {:error, error} = Canvases.create_canvas(file, size)
      assert error =~ "Operation is not valid"
    end
  end

  describe "update_canvas/3" do
    setup(context) do
      file = %Plug.Upload{
        filename: context.filename,
        path: "test/fixtures/canvases/#{context.filename}"
      }

      %{upload: file}
    end

    @tag filename: "rectangles_with_flood_fill_1.txt"
    test "updates canvas when data is valid", %{upload: file} do
      {:ok, canvas} = insert(:canvas)
      size = %{"width" => 32, "height" => 12}

      {:ok, updated_canvas} = Canvases.update_canvas(canvas, file, size)

      refute canvas.content == updated_canvas.content
    end

    @tag filename: "rectangles_error.txt"
    test "returns validation errors when data is not valid", %{upload: file} do
      {:ok, canvas} = insert(:canvas)
      size = %{"width" => 32, "height" => 12}

      assert {:error, error} = Canvases.update_canvas(canvas, file, size)
      assert error =~ "Operation is not valid"
    end
  end
end
