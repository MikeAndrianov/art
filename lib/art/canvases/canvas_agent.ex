defmodule Art.Canvases.CanvasAgent do
  use Agent
  alias Art.Canvases.Operations.Rectangle # TODO: not sure if it's okay to call here Rectangle
  alias Art.Canvases.Operation # TODO: not sure if it's okay to call here Rectangle

  def start_link(canvas_size) do
    initial_value = %{
      canvas_size: canvas_size,
      operations: [],
      points: []
    }

    Agent.start_link(fn -> initial_value end)
  end

  def operations(pid), do: Agent.get(pid, &(&1[:operations]))

  def size(pid), do: Agent.get(pid, &(&1[:canvas_size]))
  # def size(pid), do: Agent.get(pid, &({&1[:max_column], &1[:max_row]}))

  def apply_operation(pid, operation) do
    Agent.update(
      pid,
      fn state ->
        operations = [operation | state[:operations]]
        points = Operation.execute(operation, state.points, state.canvas_size) ++ state.points

        state
        |> Map.put(:operations, operations) # check validation?
        |> Map.put(:points, points)
      end
    )
  end

  # defp recalculate_size(state, %Rectangle{} = operation) do
  #   # TODO: this is code duplication. Get rid of it
  #   [upper_left_col, upper_left_row] = operation.start_coordinates
  #   lower_right_col = upper_left_col + operation.width - 1
  #   lower_right_row = upper_left_row + operation.height - 1

  #   state
  #   |> Map.put(:max_column, max(state.max_column, lower_right_col))
  #   |> Map.put(:max_row, max(state.max_row, lower_right_row))
  # end

  # defp recalculate_size(state, _), do: state
end
