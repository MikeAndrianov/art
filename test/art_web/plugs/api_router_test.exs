defmodule ArtWeb.ApiRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use DbCleaner
  import Art.Factory

  alias ArtWeb.ApiRouter

  describe "POST /api/canvases" do
    setup(context) do
      conn =
        conn(
          :post,
          "/canvases",
          %{
            "canvas" => %{
              "width" => "32",
              "height" => "12"
            },
            "file" => %Plug.Upload{
              path: "test/fixtures/canvases/#{context.filename}"
            }
          }
        )
        |> ApiRouter.call(%{})

      %{conn: conn}
    end

    @tag filename: "rectangles_1.txt"
    test "creates canvas", %{conn: conn} do
      expected_content =
        "                                \n" <>
          "                                \n" <>
          "   @@@@@                        \n" <>
          "   @XXX@  XXXXXXXXXXXXXX        \n" <>
          "   @@@@@  XOOOOOOOOOOOOX        \n" <>
          "          XOOOOOOOOOOOOX        \n" <>
          "          XOOOOOOOOOOOOX        \n" <>
          "          XOOOOOOOOOOOOX        \n" <>
          "          XXXXXXXXXXXXXX        \n" <>
          "                                \n" <>
          "                                \n" <>
          "                                \n"

      json_response = Jason.decode!(conn.resp_body)

      assert json_response["content"] == expected_content
      assert conn.status == 201
    end

    @tag filename: "rectangles_2.txt"
    test "returns certain keys", %{conn: conn} do
      json_response = Jason.decode!(conn.resp_body)

      assert Map.keys(json_response) == ["content", "id", "inserted_at", "updated_at"]
    end

    @tag filename: "rectangles_error.txt"
    test "returns error message when file is invalid", %{conn: conn} do
      assert conn.resp_body =~ "Operation is not valid"
      assert conn.status == 422
    end
  end

  describe "PATCH /api/canvases/:id" do
    setup(context) do
      {:ok, canvas} = insert(:canvas)

      conn =
        conn(
          :patch,
          "/canvases/#{canvas.id}",
          %{
            "canvas" => %{
              "width" => "32",
              "height" => "12"
            },
            "file" => %Plug.Upload{
              path: "test/fixtures/canvases/#{context.filename}"
            }
          }
        )
        |> ApiRouter.call(%{})

      %{conn: conn, canvas: canvas}
    end

    @tag filename: "rectangles_with_flood_fill_1.txt"
    test "updates canvas", %{conn: conn, canvas: canvas} do
      updated_canvas = Art.Canvases.get_canvas(canvas.id)
      json_response = Jason.decode!(conn.resp_body)

      assert json_response["content"] == updated_canvas.content
      assert conn.status == 200
    end

    @tag filename: "rectangles_2.txt"
    test "returns certain keys", %{conn: conn} do
      json_response = Jason.decode!(conn.resp_body)

      assert Map.keys(json_response) == ["content", "id", "inserted_at", "updated_at"]
    end

    @tag filename: "rectangles_error.txt"
    test "returns error message when file is invalid", %{conn: conn} do
      assert conn.resp_body =~ "Operation is not valid"
      assert conn.status == 422
    end
  end
end
