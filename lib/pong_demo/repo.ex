defmodule PongDemo.Repo do
  use Ecto.Repo,
    otp_app: :pong_demo,
    adapter: Ecto.Adapters.Postgres
end
