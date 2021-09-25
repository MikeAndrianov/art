defmodule ArtWeb.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ArtWeb.Router

  describe "POST /canvases" do
    setup context do
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
        |> Router.call(%{})

      %{conn: conn}
    end

    @tag filename: "rectangles_1.txt"
    test "creates canvas and returns drawn content", %{conn: conn} do
      expected_body =
        "                                \n" <>
          "                                \n" <>
          "   @@@@@                        \n" <>
          "   @   @  XXXXXXXXXXXXXX        \n" <>
          "   @@@@@  X            X        \n" <>
          "          X            X        \n" <>
          "          X            X        \n" <>
          "          X            X        \n" <>
          "          XXXXXXXXXXXXXX        \n" <>
          "                                \n" <>
          "                                \n" <>
          "                                \n"

      assert conn.resp_body == expected_body
      assert conn.status == 200
    end

    @tag filename: "rectangles_error.txt"
    test "returns error message when file is invalid", %{conn: conn} do
      assert conn.resp_body =~ "Operation is not valid"
      assert conn.status == 422
    end
  end
end
