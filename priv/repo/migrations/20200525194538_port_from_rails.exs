defmodule Pickup.Repo.Migrations.PortFromRails do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :uid, :string
      add :name, :string
      add :email, :string
      add :provider, :string
      add :avatar_url, :string
      add :credentials, :binary

      timestamps(type: :timestamptz)
    end

    create unique_index(:users, [:uid, :provider], name: :unique_uid_for_provider)

    create table(:games) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :slug, :string
      add :defaults, :map

      timestamps(type: :timestamptz)
    end

    create unique_index(:games, [:slug], name: :unique_slug_for_game)

    create table(:matches) do
      add(:game_id, references(:games, on_delete: :delete_all))
      add(:user_id, references(:users, on_delete: :delete_all))

      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :description, :text
      add :start, :naive_datetime
      add :duration, :integer
      add :slots, :integer

      timestamps(type: :timestamptz)
    end

    create unique_index(:matches, [:name], name: :unique_name_for_match)

    create table(:reservations) do
      add(:match_id, references(:matches, on_delete: :delete_all))
      add(:user_id, references(:users, on_delete: :delete_all))

      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :standby, :boolean, default: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:reservations, [:match_id, :user_id], name: :unique_user_reservation)
  end
end
