defmodule Art.Canvases.Operation do
  alias Art.Canvases.Operations.{FloodFill, Rectangle}

  # TODO: rename
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
    regex =
      ~r/(?<operation_type>.+)\s+at\s+\[(?<upper_left_x>\d+),\s*(?<upper_left_y>\d+)\]\s+with\s+(?<params>.*)/

    regex
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
end
