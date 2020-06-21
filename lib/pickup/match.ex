defmodule Pickup.Match do
  use Ecto.Schema

  import Ecto.{Changeset}

  alias Pickup.{Match}
  alias Pickup.Match.{Adjective, Noun}

  schema "matches" do
    belongs_to :game, Pickup.Game
    belongs_to :host, Pickup.User, foreign_key: :user_id
    has_many :reservations, Pickup.Reservation

    field :name, :string
    field :description, :string
    field :start, :naive_datetime
    field :duration, :integer
    field :slots, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:name, :description, :start, :duration, :slots])
    |> cast_assoc(:reservations)
    |> validate_required([:name, :start])
  end

  @doc """
  iex> Match.generate_name(1)
  "Adamant Momentum"

  Again ...
  iex> Match.generate_name(1)
  "Adamant Momentum"

  iex> Match.generate_name(2) == "Adamant Momentum"
  false
  """
  def generate_name(priors_count) do
    seed =
      "GLHFDD"
      |> String.to_charlist()
      |> Enum.chunk_every(2)
      |> Enum.map(&Enum.sum(&1))
      |> List.to_tuple()

    :rand.seed(:exrop, seed)

    [Adjective.all(), Noun.all()]
    |> Enum.reduce([], fn words, name_parts ->
      name_parts ++ [Enum.shuffle(words) |> Enum.at(priors_count)]
    end)
    |> Enum.join(" ")
  end
end
