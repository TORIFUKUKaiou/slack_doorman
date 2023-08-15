defmodule SlackDoorman.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :image, :string
    field :display_name, :string
    field :slack_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :slack_id, :image])
    |> validate_required([:display_name, :slack_id, :image])
    |> unique_constraint(:slack_id)
  end
end
