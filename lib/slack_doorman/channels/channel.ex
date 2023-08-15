defmodule SlackDoorman.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :name, :string
    field :slack_id, :string

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :slack_id])
    |> validate_required([:name, :slack_id])
    |> unique_constraint(:slack_id)
    |> unique_constraint(:name)
  end
end
