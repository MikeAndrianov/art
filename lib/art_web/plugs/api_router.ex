defmodule ArtWeb.ApiRouter do
  use Plug.Router
  alias Art.Canvases

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/canvases" do
    send_resp(
      conn,
      Plug.Conn.Status.code(:ok),
      Jason.encode!(Canvases.list_canvases())
    )
  end

  post "/canvases" do
    case Canvases.create_canvas(conn.body_params["file"], canvas_size(conn.body_params)) do
      {:ok, canvas} ->
        send_resp(conn, Plug.Conn.Status.code(:created), Jason.encode!(canvas))

      {:error, error_message} ->
        send_resp(conn, Plug.Conn.Status.code(:unprocessable_entity), Jason.encode!(%{error: error_message})) # TODO: handle error from canvas changeset
    end
  end

  patch "/canvases/:id" do
    with canvas when not is_nil(canvas) <- Canvases.get_canvas(conn.params["id"]),
      {:ok, updated_canvas} <- Canvases.update_canvas(canvas, conn.body_params["file"], canvas_size(conn.body_params)) do
        send_resp(conn, Plug.Conn.Status.code(:ok), Jason.encode!(updated_canvas))
      else
        nil ->
          send_resp(conn, Plug.Conn.Status.code(:not_found), Jason.encode!(%{error: "Not found"}))

        {:error, error_message} ->
          send_resp(conn, Plug.Conn.Status.code(:unprocessable_entity), Jason.encode!(%{error: error_message}))
      end
  end

  defp canvas_size(params) do
    Enum.into(
      params["canvas"],
      %{},
      fn {k, v} ->
        {number, _} = Integer.parse(v)
        {k, number}
      end
    )
  end

  match _ do
    send_resp(conn, Plug.Conn.Status.code(:not_found), Jason.encode!(%{error: "Not found"}))
  end
end
