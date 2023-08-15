defmodule SlackDoorman.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :slack_id, :string

      timestamps()
    end

    create unique_index(:channels, [:slack_id])
    create unique_index(:channels, [:name])
  end
end
