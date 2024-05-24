defmodule PongDemo.Systems.ClientEventHandler do
  @moduledoc """
  Documentation for ClientEventHandler system.
  """
  @behaviour ECSx.System

  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YPosition
  alias PongDemo.Components.XVelocity
  alias PongDemo.Components.YVelocity
  alias PongDemo.Components.YSize
  alias PongDemo.Components.ImageFile
  alias PongDemo.Components.Score
  alias PongDemo.Components.PlayerSpawned
  alias PongDemo.Components.PlayerPaddle
  alias PongDemo.Components.CpuPaddle

  @impl ECSx.System
  def run do
    client_events = ECSx.ClientEvents.get_and_clear()

    Enum.each(client_events, &process_one/1)
  end

  defp process_one({player, :spawn_player_paddle}) do
    # paddles only move vertically, so they don't need an XVelocity
    XPosition.add(player, 1)
    YPosition.add(player, 25)
    YVelocity.add(player, 0)
    YSize.add(player, 5)
    Score.add(player, 0)

    PlayerPaddle.add(player)
    ImageFile.add(player, "paddle.svg")
    PlayerSpawned.add(player)
  end

  defp process_one({cpu, :spawn_cpu_paddle}) do
    # paddles only move vertically, so they don't need an XVelocity
    XPosition.add(cpu, 88)
    YPosition.add(cpu, 25)
    YVelocity.add(cpu, 0)
    YSize.add(cpu, 5)
    Score.add(cpu, 0)

    CpuPaddle.add(cpu)
    ImageFile.add(cpu, "paddle.svg")
    PlayerSpawned.add(cpu)
  end

  defp process_one({ball, :spawn_ball}) do
    x_velocity = Enum.random([-1, 1])
    y_velocity = Enum.random([-1, 1])
    XPosition.add(ball, 45)
    YPosition.add(ball, 25)
    XVelocity.add(ball, x_velocity)
    YVelocity.add(ball, y_velocity)

    ImageFile.add(ball, "ball.svg")
    PlayerSpawned.add(ball)
  end

  defp process_one({ball, :reset_ball}) do
    x_velocity = Enum.random([-1, 1])
    y_velocity = Enum.random([-1, 1])
    XPosition.update(ball, 45)
    YPosition.update(ball, 25)
    XVelocity.update(ball, x_velocity)
    YVelocity.update(ball, y_velocity)
  end

  defp process_one({player, {:move, :north}}), do: YVelocity.update(player, -1)
  defp process_one({player, {:move, :south}}), do: YVelocity.update(player, 1)
  defp process_one({player, :stop_move}), do: YVelocity.update(player, 0)
end
