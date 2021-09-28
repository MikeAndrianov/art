defmodule Art.Canvases.Operation do
  @moduledoc ~S"""
  Operation module is an entry point for creation different operations such as
  Rectangle or FloodFill.
  """

  alias Art.Canvases.Operations.{FloodFill, Rectangle}

  @operation_regex ~r/(?<operation_type>.+)\s+at\s+\[(?<upper_left_row>\d+),\s*(?<upper_left_column>\d+)\]\s+with\s+(?<params>.*)/

  @doc """
  Recieves string, parses it and builds corresponding struct or returns error

  ## Examples

      iex> operation = "Rectangle at [1, 1] with width 3, height 2, outline character: none, fill: ."
      iex> Art.Canvases.Operation.build(operation)
      {
        :ok,
        %Art.Canvases.Operations.Rectangle{
          start_coordinates: [1, 1],
          width: 3,
          height: 2,
          outline_character: nil,
          fill: ".",
          id: nil
        }
      }

      iex> operation = "Flood fill at [2, 3] with fill character *"
      iex> Art.Canvases.Operation.build(operation)
      {
        :ok,
        %Art.Canvases.Operations.FloodFill{
          start_coordinates: [2, 3],
          fill_character: "*",
          id: nil
        }
      }

      iex> Art.Canvases.Operation.build("random string")
      {:error, "Operation type is not valid"}

  """
  def build(operation_string) do
    case attrs = parse(operation_string) do
      %{operation_type: "Rectangle"} ->
        Rectangle.build(attrs)

      %{operation_type: "Flood fill"} ->
        FloodFill.build(attrs)

      _ ->
        {:error, "Operation type is not valid"}
    end
  end

  @doc """
  Recieves operation and builds list of points

  ## Examples

      iex> operation = "Rectangle at [1, 1] with width 3, height 3, outline character: ., fill: none"
      iex> {:ok, rectangle} = Art.Canvases.Operation.build(operation)
      iex> Art.Canvases.Operation.execute(rectangle, [], %{})
      [
        %Art.Canvases.Operations.Point{column: 1, row: 1, content: "."},
        %Art.Canvases.Operations.Point{column: 1, row: 3, content: "."},
        %Art.Canvases.Operations.Point{column: 2, row: 1, content: "."},
        %Art.Canvases.Operations.Point{column: 2, row: 3, content: "."},
        %Art.Canvases.Operations.Point{column: 3, row: 1, content: "."},
        %Art.Canvases.Operations.Point{column: 3, row: 3, content: "."},
        %Art.Canvases.Operations.Point{column: 1, row: 2, content: "."},
        %Art.Canvases.Operations.Point{column: 3, row: 2, content: "."}
      ]

      iex> operation = "Flood fill at [0, 0] with fill character -"
      iex> {:ok, flood_fill} = Art.Canvases.Operation.build(operation)
      iex> Art.Canvases.Operation.execute(flood_fill, [], %{"width" => 2, "height" => 2})
      [
        %Art.Canvases.Operations.Point{column: 0, row: 1, content: "-"},
        %Art.Canvases.Operations.Point{column: 1, row: 1, content: "-"},
        %Art.Canvases.Operations.Point{column: 1, row: 0, content: "-"},
        %Art.Canvases.Operations.Point{column: 0, row: 0, content: "-"}
      ]
  """
  def execute(%Rectangle{} = rectangle, _, _) do
    Rectangle.build_points(rectangle)
  end

  def execute(%FloodFill{} = flood_fill, existing_points, canvas_size) do
    FloodFill.build_points(flood_fill, canvas_size, existing_points)
  end

  def execute(_, _, _) do
  end

  defp parse("") do
  end

  defp parse(operation) do
    @operation_regex
    |> Regex.named_captures(operation)
    |> parse_params
    |> Enum.into(%{}, fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.delete(:params)
  end

  defp parse_params(%{"params" => params} = attrs) do
    parsed_params =
      params
      |> String.split([", ", ","], trim: true)
      |> Enum.into(
        %{},
        fn param ->
          %{"key" => key, "value" => value} =
            Regex.named_captures(~r/(?<key>[\w+\s*]+):*\s+(?<value>.+)/, param)

          {
            # it's needed for "outline character"
            String.replace(key, " ", "_"),
            value
          }
        end
      )

    attrs
    |> Map.put("start_coordinates", [attrs["upper_left_row"], attrs["upper_left_column"]])
    |> Map.drop(["upper_left_row", "upper_left_column"])
    |> Map.merge(parsed_params)
  end

  defp parse_params(nil), do: %{}
end
