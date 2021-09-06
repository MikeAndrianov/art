defmodule Art.Canvases.Operation do
  @moduledoc ~S"""
  Operation module is an entry point for creation different operations such as
  Rectangle or FloodFill.
  """

  alias Art.Canvases.Operations.{FloodFill, Rectangle}

  @operation_regex ~r/(?<operation_type>.+)\s+at\s+\[(?<upper_left_x>\d+),\s*(?<upper_left_y>\d+)\]\s+with\s+(?<params>.*)/

  @doc """
  Recieves string, parses it and builds corresponding struct or return error

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
      # todo: check for multiple whitespaces
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
    |> Map.put("start_coordinates", [attrs["upper_left_x"], attrs["upper_left_y"]])
    |> Map.drop(["upper_left_x", "upper_left_y"])
    |> Map.merge(parsed_params)
  end

  defp parse_params(nil), do: %{}
end
