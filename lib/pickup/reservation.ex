defmodule Pickup.Reservation do
  use Ecto.Schema

  import Ecto.{Changeset}

  alias Pickup.{Reservation}

  schema "reservations" do
    belongs_to :user, Pickup.User
    belongs_to :match, Pickup.Match

    field :standby, :boolean

    timestamps(type: :utc_datetime)
  end

  def changeset(%Reservation{} = reservation, attrs) do
    reservation
    |> cast(attrs, [:user_id, :match_id, :standby])
    |> validate_required([:user_id, :match_id])
    |> unique_constraint(:unique_user_reservation, name: :unique_user_reservation)
  end
end
