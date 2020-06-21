defmodule Pickup.Users do
  alias Pickup.{Repo, User}

  import Ecto.{Query}

  def all do
    Repo.all(User)
  end

  def get!(id), do: from(user in User, where: user.id == ^id) |> Repo.one!()
  def get_by_uid(uid), do: from(user in User, where: user.uid == ^uid) |> Repo.one()

  def find_or_create_ueberauth(attrs \\ %{}) do
    case get_by_uid(attrs.uid) do
      nil ->
        %User{}
        |> User.ueberauth_changeset(attrs)
        |> Repo.insert()

      user ->
        {:ok, user}
    end
  end

  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete(%User{} = user) do
    Repo.delete(user)
  end

  def change(%User{} = user) do
    User.changeset(user, %{})
  end
end
