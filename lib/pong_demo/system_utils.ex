defmodule PongDemo.SystemUtils do
  @moduledoc """
  Useful math functions used by multiple systems.
  """

  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YPosition
  alias PongDemo.Components.YSize

  def distance_between(entity_1, entity_2) do
    x_1 = XPosition.get(entity_1)
    x_2 = XPosition.get(entity_2)
    y_1 = YPosition.get(entity_1)
    y_2 = YPosition.get(entity_2)
    y_size = YSize.get(entity_1)

    x = abs(x_1 - x_2)

    distance = Enum.reduce(0..y_size-1, 0, fn i, acc ->
      paddle_y = y_1 + i

      y = abs(paddle_y - y_2)

      acc + :math.sqrt(x ** 2 + y ** 2)
    end)

    distance / y_size
  end
end
