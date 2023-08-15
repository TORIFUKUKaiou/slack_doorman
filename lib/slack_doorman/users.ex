defmodule SlackDoorman.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias SlackDoorman.Repo

  alias SlackDoorman.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def insert_all(users) do
    entries =
      users
      |> Enum.map(fn %{
                       "id" => slack_id,
                       "profile" => profile
                     } ->
        display_name = Map.get(profile, "display_name", "燃える闘魂")

        image =
          Map.get(profile, "image_512", "https://a.slack-edge.com/80588/img/slackbot_512.png")

        %{
          slack_id: slack_id,
          display_name: display_name,
          image: image,
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        }
      end)

    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    Repo.insert_all(User, entries,
      on_conflict: {:replace, [:display_name, :image]},
      conflict_target: [:slack_id],
      placeholders: %{timestamp: timestamp}
    )
  end

  def get_user_by(slack_id), do: Repo.get_by(User, slack_id: slack_id)
end
