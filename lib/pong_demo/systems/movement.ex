defmodule PongDemo.Systems.Movement do
  @moduledoc """
  Documentation for Movement system.
  """
  @behaviour ECSx.System

  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YPosition
  alias PongDemo.Components.XVelocity
  alias PongDemo.Components.YVelocity
  alias PongDemo.Components.YSize

  @game_world_width Application.compile_env(:pong_demo, :game_world_width)
  @game_world_height Application.compile_env(:pong_demo, :game_world_height)

  @impl ECSx.System
  def run do
    max_x_position = @game_world_width - 1

    for {entity, x_velocity} <- XVelocity.get_all() do
      new_x_position =
        entity
        |> XPosition.get()
        |> calculate_new_position(x_velocity, max_x_position)

      XPosition.update(entity, new_x_position)
    end

    # Once the x-values are updated, do the same for the y-values
    for {entity, y_velocity} <- YVelocity.get_all() do
      max_y_position = get_max_y_position(entity)

      new_y_position =
        entity
        |> YPosition.get()
        |> calculate_new_position(y_velocity, max_y_position)

      YPosition.update(entity, new_y_position)
    end

    :ok
  end

  defp calculate_new_position(current_position, velocity, max_position) do
    new_position = current_position + velocity
    new_position = Enum.min([new_position, max_position])
    Enum.max([new_position, 0])
  end

  defp get_max_y_position(entity) do
    entity_size = YSize.get(entity, 1) - 1

    @game_world_height - 1 - entity_size
  end
end
