defmodule Notex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, unique: true, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
