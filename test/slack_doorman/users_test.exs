defmodule SlackDoorman.UsersTest do
  use SlackDoorman.DataCase

  alias SlackDoorman.Users

  describe "users" do
    alias SlackDoorman.Users.User

    import SlackDoorman.UsersFixtures

    @invalid_attrs %{image: nil, display_name: nil, slack_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        image: "some image",
        display_name: "some display_name",
        slack_id: "some slack_id"
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.image == "some image"
      assert user.display_name == "some display_name"
      assert user.slack_id == "some slack_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        image: "some updated image",
        display_name: "some updated display_name",
        slack_id: "some updated slack_id"
      }

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.image == "some updated image"
      assert user.display_name == "some updated display_name"
      assert user.slack_id == "some updated slack_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
