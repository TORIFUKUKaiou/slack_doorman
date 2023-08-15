defmodule SlackDoorman.Repo do
  use Ecto.Repo,
    otp_app: :slack_doorman,
    adapter: Ecto.Adapters.Postgres
end
