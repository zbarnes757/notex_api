defmodule Notex.NotesTest do
  use Notex.DataCase
  import Notex.Factory

  alias Notex.{Accounts, Notes}

  describe "note" do
    alias Notex.Notes.Note

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(params_for(:user))
        |> Accounts.create_user()

      user
    end

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_note()

      note
    end

    test "list_note/0 returns all note" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert Notes.list_note() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert Notes.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      user = user_fixture()

      assert {:ok, %Note{} = note} =
               @valid_attrs
               |> Map.put(:user_id, user.id)
               |> Notes.create_note()

      assert note.content == "some content"
      assert note.title == "some title"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert {:ok, %Note{} = note} = Notes.update_note(note, @update_attrs)
      assert note.content == "some updated content"
      assert note.title == "some updated title"
    end

    test "update_note/2 with invalid data returns error changeset" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
      assert note == Notes.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert {:ok, %Note{}} = Notes.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      user = user_fixture()
      note = note_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Notes.change_note(note)
    end
  end
end
