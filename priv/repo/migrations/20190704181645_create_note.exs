defmodule Notex.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:note, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:note, [:user_id])
  end
end
