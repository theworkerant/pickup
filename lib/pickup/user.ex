defmodule Pickup.User do
  use Ecto.Schema

  alias Pickup.{User}

  import Ecto.{Changeset}

  schema "users" do
    field :uid, :string
    field :provider, :string
    field :email, :string
    field :name, :string
    field :avatar_url, :string
    field :credentials, Pickup.Encrypted.Map

    timestamps(type: :utc_datetime)
  end

  def ueberauth_changeset(%User{} = user, attrs) do
    changeset(
      user,
      %{
        uid: attrs.uid,
        provider: "#{attrs.provider}",
        name: attrs.extra.raw_info.user["username"],
        avatar_url: attrs.info.image,
        email: attrs.info.email,
        credentials: Map.from_struct(attrs.credentials)
      }
    )
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:provider, :name, :email, :uid, :avatar_url, :credentials])
    |> validate_required([:provider, :name, :email, :uid, :avatar_url, :credentials])
    |> unique_constraint(:unique_uid_for_provider)
  end
end
