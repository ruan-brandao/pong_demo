defmodule PongDemo.Systems.Scoring do
  @moduledoc """
  Documentation for Scoring system.
  """
  @behaviour ECSx.System

  alias PongDemo.Components.PlayerPaddle
  alias PongDemo.Components.CpuPaddle
  alias PongDemo.Components.Score
  alias PongDemo.Components.XPosition
  alias PongDemo.Components.XVelocity

  @game_world_width Application.compile_env(:pong_demo, :game_world_width)

  @impl ECSx.System
  def run do
    balls = XVelocity.get_all()

    Enum.each(balls, &update_scores(&1))
  end

  defp update_scores({ball, _}) do
    max_x_position = @game_world_width - 1
    x_position = XPosition.get(ball)

    case x_position do
      0 -> increment_cpu_score(ball)
      ^max_x_position -> increment_player_score(ball)
      _ -> nil
    end
  end

  defp increment_player_score(ball) do
    player_paddles = PlayerPaddle.get_all()
    increment_scores(player_paddles, ball)
  end

  defp increment_cpu_score(ball) do
    cpu_paddles = CpuPaddle.get_all()
    increment_scores(cpu_paddles, ball)
  end

  defp increment_scores(paddles, ball) do
    Enum.each(paddles, fn paddle ->
      current_score = Score.get(paddle)

      Score.update(paddle, current_score + 1)
    end)

    ECSx.ClientEvents.add(ball, :reset_ball)
  end
end
