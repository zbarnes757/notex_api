defmodule Notex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> put_password_hash()
    |> unique_constraint(:username)
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username])
    |> put_password_hash()
    |> unique_constraint(:username)
  end

  @spec verify_password(__MODULE__.t(), String.t()) :: {:ok, nil} | {:error, :invalid}
  def verify_password(%__MODULE__{password_hash: password_hash}, password) do
    case Bcrypt.verify_pass(password, password_hash) do
      true ->
        {:ok, nil}

      false ->
        {:error, :invalid}
    end
  end

  # Helpers

  defp put_password_hash(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        change(changeset, Bcrypt.add_hash(password))
    end
  end
end
