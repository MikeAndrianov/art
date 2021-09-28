defmodule ArtWeb.Renderer do
  import Plug.Conn

  @base_templates_path "lib/art_web/templates"

  def render(conn, template, assigns \\ [], base_templates_path \\ @base_templates_path) do
    body =
      base_templates_path
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(normalized_assigns(assigns))

    send_resp(conn, conn.status || 200, body)
  end

  defp normalized_assigns(assigns) when is_map(assigns), do: Map.to_list(assigns)
  defp normalized_assigns(assigns), do: assigns
end
