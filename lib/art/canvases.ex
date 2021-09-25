defmodule Art.Canvases do
  @moduledoc ~S"""
  The Canvases context.
  """

  alias Art.Canvases.{Canvas, Operation}

  @doc """
  Returns the list of canvases.

  ## Examples

      iex> list_canvases()
      [%Art.Canvases.Canvas{}, ...]

  """
  def list_canvases() do
  end

  @doc """
  Creates canvas or returns error.

  ## Examples

      iex> create_canvas(file, canvas_size)
      {:ok, %Art.Canvases.Canvas{}}

      iex> create_canvas(file, canvas_size)
      {:error, "error message"}

  """
  def create_canvas(file, canvas_size) do
    case build_points(file, canvas_size) do
      {:error, _} = error ->
        error

      points ->
        Canvas.build(points, canvas_size)
    end
  end

  def draw_canvas(canvas), do: Canvas.draw(canvas)

 @doc """
  Updates canvas or returns error.

  ## Examples

      iex> update_canvas()
      {:ok, %Art.Canvases.Canvas{}}

      iex> update_canvas()
      {:error, "error message"}

  """
  def update_canvas() do
  end

  defp build_points(file, canvas_size) do
    try do
      file.path
      |> File.stream!()
      |> Stream.scan([], fn operation_string, existing_points ->
        case Operation.build(operation_string) do
          {:ok, operation} ->
            Operation.execute(operation, existing_points, canvas_size)

          # TODO: replace this with real errors from Operation.build
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
