defmodule ArtWeb.Router do
  use Plug.Router
  use ArtWeb, :renderer
  alias Art.Canvases

  plug(:match)
  plug(:dispatch)

  forward("/api", to: ArtWeb.ApiRouter)

  get "/canvases" do
    canvases = Canvases.list_canvases()

    render(conn, "canvases/index.html", canvases: canvases)
  end

  match _ do
    send_resp(conn, Plug.Conn.Status.code(:not_found), "Not found")
  end
end
