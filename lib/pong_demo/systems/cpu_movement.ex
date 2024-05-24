defmodule PongDemo.Systems.CpuMovement do
  @moduledoc """
  Documentation for CpuMovement system.
  """
  @behaviour ECSx.System

  alias PongDemo.Components.YPosition
  alias PongDemo.Components.YVelocity
  alias PongDemo.Components.XVelocity
  alias PongDemo.Components.CpuPaddle

  @impl ECSx.System
  def run do
    balls = XVelocity.get_all()

    Enum.each(balls, &update_paddle_velocity(&1))
  end

  defp update_paddle_velocity({ball, _}) do
    cpu_paddles = CpuPaddle.get_all()
    ball_position = YPosition.get(ball)
    Enum.each(cpu_paddles, fn paddle ->
      paddle_position = YPosition.get(paddle)

      cond do
        ball_position > paddle_position -> YVelocity.update(paddle, 1)
        ball_position < paddle_position -> YVelocity.update(paddle, -1)
        ball_position == paddle_position -> YVelocity.update(paddle, 0)
      end
    end)
  end
end
