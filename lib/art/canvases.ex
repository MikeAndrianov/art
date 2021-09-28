defmodule Art.Canvases do
  @moduledoc ~S"""
  The Canvases context.
  """

  import Ecto.Query
  alias Art.Repo
  alias Art.Canvases.{Canvas, Operation}

  @doc """
  Finds and returns existing canvas by id
  """
  def get_canvas(id) do
    Repo.get(Canvas, id)
  end

  @doc """
  Returns the list of canvases.
  """
  def list_canvases() do
    from(c in Canvas, order_by: [desc: c.id])
    |> Repo.all
  end

  @doc """
  Creates canvas or returns error.
  """
  def create_canvas(file, canvas_size) do
    save_canvas(%Canvas{}, file, canvas_size)
  end

  @doc """
  Updates canvas or returns error.
  """
  def update_canvas(canvas, file, canvas_size) do
    save_canvas(canvas, file, canvas_size)
  end

  defp save_canvas(canvas, file, canvas_size) do
    case build_points(file, canvas_size) do
      {:error, _} = error ->
        error

      points ->
        attrs = Map.put(canvas_size, "points", points)

        canvas
        |> Canvas.changeset(attrs)
        |> Repo.insert_or_update()
    end
  end

  defp build_points(_file, %{"width" => width, "height" => height}) when width < 1 or height < 1 do
    {:error, "Invalid canvas size"}
  end

  defp build_points(file, canvas_size) do
    try do
      file.path
      |> File.stream!()
      |> Stream.scan([], fn operation_string, existing_points ->
        case Operation.build(operation_string) do
          {:ok, operation} ->
            Operation.execute(operation, existing_points, canvas_size)

          {:error, _error} ->
            throw("Operation is not valid: \"#{operation_string}\"")
        end
      end)
      |> Enum.flat_map(& &1)
    catch
      error -> {:error, error}
    end
  end
end
