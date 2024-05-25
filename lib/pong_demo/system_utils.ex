defmodule PongDemo.SystemUtils do
  @moduledoc """
  Useful math functions used by multiple systems.
  """

  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YPosition
  alias PongDemo.Components.YSize

  def distance_between(paddle, ball) do
    paddle_x = XPosition.get(paddle)
    ball_x = XPosition.get(ball)
    paddle_y = YPosition.get(paddle)
    ball_y = YPosition.get(ball)
    paddle_size = YSize.get(paddle)

    x = abs(paddle_x - ball_x)

    distance = Enum.reduce(0..paddle_size-1, 0, fn i, acc ->
      paddle_y = paddle_y + i

      y = abs(paddle_y - ball_y)

      acc + :math.sqrt(x ** 2 + y ** 2)
    end)

    distance / paddle_size
  end
end
