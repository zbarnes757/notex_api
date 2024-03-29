defmodule Notex.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias Notex.Repo

  alias Notex.Notes.Note

  @doc """
  Returns the list of note.

  ## Examples

      iex> list_note()
      [%Note{}, ...]

  """
  def list_note(opts \\ []) do
    filter = Keyword.get(opts, :filter, %{})

    Note
    |> filter_by_user_id(filter)
    |> Repo.all()
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note(id, opts \\ []) do
    filter = Keyword.get(opts, :filter, %{})

    Note
    |> filter_by_user_id(filter)
    |> Repo.get(id)
    |> case do
      nil ->
        {:error, :not_found}

      note ->
        {:ok, note}
    end
  end

  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{source: %Note{}}

  """
  def change_note(%Note{} = note) do
    Note.changeset(note, %{})
  end

  # Helpers

  defp filter_by_user_id(query, %{user_id: user_id}) do
    query
    |> where(user_id: ^user_id)
  end

  defp filter_by_user_id(query, _), do: query
end
