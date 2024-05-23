defmodule PongDemoWeb.GameLive do
  use PongDemoWeb, :live_view

  alias PongDemo.Components.XPosition
  alias PongDemo.Components.YPosition
  alias PongDemo.Components.YSize
  alias PongDemo.Components.ImageFile
  alias PongDemo.Components.PlayerSpawned

  def mount(_params, _session, socket) do
    game_world_width = Application.fetch_env!(:pong_demo, :game_world_width)
    game_world_height = Application.fetch_env!(:pong_demo, :game_world_height)
    player = %{id: Ecto.UUID.generate()}
    cpu = %{id: Ecto.UUID.generate()}
    ball_entity_id = Ecto.UUID.generate()

    socket =
      socket
      |> assign(player_entity: player.id)
      |> assign(cpu_entity: cpu.id)
      |> assign(ball_entity: ball_entity_id)
      |> assign(keys: MapSet.new())
      |> assign(screen_height: game_world_height, screen_width: game_world_width)
      |> assign(x_coord: nil, y_coord: nil)
      |> assign(ball_x_coord: nil, ball_y_coord: nil)
      |> assign(loading: true)

    if connected?(socket) do
      ECSx.ClientEvents.add(player.id, :spawn_player_paddle)
      ECSx.ClientEvents.add(cpu.id, :spawn_cpu_paddle)
      ECSx.ClientEvents.add(ball_entity_id, :spawn_ball)
      # The first load will now have additional responsibilities
      send(self(), :first_load)
    end

    {:ok, socket}
  end

  def handle_info(:first_load, socket) do
    # Don't start fetching components until after spawn is complete!
    :ok = wait_for_spawn(socket.assigns.player_entity, socket.assigns.cpu_entity, socket.assigns.ball_entity)

    socket =
      socket
      |> assign_player_paddle()
      |> assign_cpu_paddle()
      |> assign_ball()
      |> assign(loading: false)

    # We want to keep up-to-date on this info
    :timer.send_interval(50, :refresh)

    {:noreply, socket}
  end

  def handle_info(:refresh, socket) do
    socket =
      socket
      |> assign_player_paddle()
      |> assign_cpu_paddle()
      |> assign_ball()

    {:noreply, socket}
  end

  defp wait_for_spawn(player_entity, cpu_entity, ball_entity) do
    if PlayerSpawned.exists?(player_entity) and PlayerSpawned.exists?(ball_entity) and PlayerSpawned.exists?(cpu_entity) do
      :ok
    else
      Process.sleep(10)
      wait_for_spawn(player_entity, cpu_entity, ball_entity)
    end
  end

  defp assign_player_paddle(socket) do
    # This will run every 50ms to keep the client assigns updated
    x = XPosition.get(socket.assigns.player_entity)
    y = YPosition.get(socket.assigns.player_entity)
    size = YSize.get(socket.assigns.player_entity)
    image = ImageFile.get(socket.assigns.player_entity)

    assign(socket, x_coord: x, y_coord: y, player_paddle_image: image, player_paddle_size: size)
  end

  defp assign_cpu_paddle(socket) do
    # This will run every 50ms to keep the client assigns updated
    x = XPosition.get(socket.assigns.cpu_entity)
    y = YPosition.get(socket.assigns.cpu_entity)
    size = YSize.get(socket.assigns.cpu_entity)
    image = ImageFile.get(socket.assigns.cpu_entity)

    assign(socket, cpu_x_coord: x, cpu_y_coord: y, cpu_paddle_image: image, cpu_paddle_size: size)
  end

  defp assign_ball(socket) do
    x = XPosition.get(socket.assigns.ball_entity)
    y = YPosition.get(socket.assigns.ball_entity)
    image = ImageFile.get(socket.assigns.ball_entity)

    assign(socket, ball_x_coord: x, ball_y_coord: y, ball_image: image)
  end

  def render(assigns) do
    ~H"""
    <div id="game" phx-window-keydown="keydown" phx-window-keyup="keyup">
      <svg viewBox={"0 0 #{@screen_width} #{@screen_height}"} preserveAspectRatio="xMinYMin slice">
        <rect width={@screen_width} height={@screen_height} fill="#9db2bf" />

        <%= if @loading do %>
          <text
            x={div(@screen_width, 2)}
            y={div(@screen_height, 2)}
            style="font: 1px serif; color: #dde6ed"
          >
            Loading...
          </text>
        <% else %>
          <%= for i <- 0..@player_paddle_size-1 do %>
          <image
            x={@x_coord}
            y={@y_coord + i}
            width="1"
            height="1"
            href={~p"/images/#{@player_paddle_image}"}
          />
          <% end %>

          <%= for i <- 0..@cpu_paddle_size-1 do %>
          <image
            x={@cpu_x_coord}
            y={@cpu_y_coord + i}
            width="1"
            height="1"
            href={~p"/images/#{@cpu_paddle_image}"}
          />
          <% end %>

          <image
            x={@ball_x_coord}
            y={@ball_y_coord}
            width="1"
            height="1"
            href={~p"/images/#{@ball_image}"}
          />
        <% end %>
      </svg>
      <br />
      <p>Game running</p>
      <p>Player ID: <%= @player_entity %></p>
      <p>Player paddle position: <%= inspect({@x_coord, @y_coord}) %></p>
      <p>Ball position: <%= inspect({@ball_x_coord, @ball_y_coord}) %></p>
    </div>
    """
  end
end
