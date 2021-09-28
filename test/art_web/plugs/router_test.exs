defmodule ArtWeb.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use DbCleaner
  import Art.Factory

  alias ArtWeb.Router

  describe "GET /canvases" do
    setup do
      {:ok, canvas} = insert(:canvas)

      conn =
        :get
        |> conn("/canvases")
        |> Router.call(%{})

      %{conn: conn, canvas: canvas}
    end

    test "renders existing canvases", %{conn: conn, canvas: canvas} do
      assert conn.resp_body =~ canvas.content
      assert conn.status == 200
    end
  end
end
