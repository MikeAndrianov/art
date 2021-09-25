defmodule ArtWeb.Router do
  use Plug.Router

  alias Art.Canvases

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  post "/canvases" do
    canvas_size =
      conn.body_params["canvas"]
      |> Enum.into(
        %{},
        fn {k, v} ->
          {number, _} = Integer.parse(v)
          {k, number}
        end
      )

    case Canvases.create_canvas(conn.body_params["file"], canvas_size) do
      {:ok, canvas} ->
        send_resp(conn, 200, Canvases.draw_canvas(canvas))

      {:error, error_message} ->
        send_resp(conn, 422, error_message)
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
