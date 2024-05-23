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
  alias PongDemo.Components.PlayerSpawned

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

    ImageFile.add(player, "paddle.svg")
    PlayerSpawned.add(player)
  end

  defp process_one({player, :spawn_cpu_paddle}) do
    # paddles only move vertically, so they don't need an XVelocity
    XPosition.add(player, 88)
    YPosition.add(player, 25)
    YVelocity.add(player, 0)
    YSize.add(player, 5)

    ImageFile.add(player, "paddle.svg")
    PlayerSpawned.add(player)
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
end
