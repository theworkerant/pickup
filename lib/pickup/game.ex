defmodule Pickup.Game do
  use Ecto.Schema

  import Ecto.{Changeset}

  alias Pickup.{Game}

  schema "games" do
    has_many :matches, Pickup.Match

    field :name, :string
    field :slug, :string
    embeds_one :defaults, Pickup.GameDefaults

    timestamps(type: :utc_datetime)
  end

  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:name, :slug])
    |> cast_embed(:defaults)
    |> validate_required([:name, :slug])
  end
end

defmodule Pickup.GameDefaults do
  use Ecto.Schema

  import Ecto.{Changeset}

  alias Pickup.{GameDefaults}

  embedded_schema do
    field :slots, :integer
    field :max, :integer
    field :description, :string
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:slots, :max, :description])
    |> validate_required([:slots, :max, :description])
  end
end
