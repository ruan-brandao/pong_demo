defmodule PongDemo.Manager do
  @moduledoc """
  ECSx manager.
  """
  use ECSx.Manager

  def setup do
    # Seed persistent components only for the first server start
    # (This will not be run on subsequent app restarts)
    :ok
  end

  def startup do
    # Load ephemeral components during first server start and again
    # on every subsequent app restart
    :ok
  end

  # Declare all valid Component types
  def components do
    [
      PongDemo.Components.CpuPaddle,
      PongDemo.Components.PlayerPaddle,
      PongDemo.Components.Score,
      PongDemo.Components.PlayerSpawned,
      PongDemo.Components.ImageFile,
      PongDemo.Components.YSize,
      PongDemo.Components.YVelocity,
      PongDemo.Components.XVelocity,
      PongDemo.Components.YPosition,
      PongDemo.Components.XPosition
    ]
  end

  # Declare all Systems to run
  def systems do
    [
      PongDemo.Systems.ClientEventHandler,
      PongDemo.Systems.Movement,
      PongDemo.Systems.CpuMovement,
      PongDemo.Systems.Collision,
      PongDemo.Systems.Scoring
    ]
  end
end
