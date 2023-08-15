defmodule SlackDoorman.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :display_name, :string, null: false
      add :slack_id, :string, null: false
      add :image, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:slack_id])
  end
end
