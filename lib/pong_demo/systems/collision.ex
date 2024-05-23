defmodule PongDemo.Systems.Collision do
  @moduledoc """
  Documentation for Collision system.
  """
  @behaviour ECSx.System

  alias PongDemo.Components.XVelocity
  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YVelocity
  alias PongDemo.Components.YPosition

  @game_world_height Application.compile_env(:pong_demo, :game_world_height)
  @game_world_width Application.compile_env(:pong_demo, :game_world_width)

  @impl ECSx.System
  def run do
    balls = XVelocity.get_all()

    Enum.each(balls, &collide_if_needed(&1))
  end

  defp collide_if_needed({ball, current_x_velocity}) do
    current_y_velocity = YVelocity.get(ball)

    # Bounces the ball back if it touches the top or bottom of the screen
    max_y_position = @game_world_height - 1
    y_position = YPosition.get(ball)

    if y_position in [0, max_y_position] do
      YVelocity.update(ball, current_y_velocity * -1)
    end

    max_x_position = @game_world_width - 1
    x_position = XPosition.get(ball)

    if x_position in [0, max_x_position] do
      XVelocity.update(ball, current_x_velocity * -1)
    end
  end
end
