defmodule NotexWeb.NoteControllerTest do
  use NotexWeb.ConnCase
  import Notex.Factory

  alias Notex.{Accounts, Notes}
  alias Notex.Notes.Note

  @create_attrs %{
    content: "some content",
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    title: "some updated title"
  }
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
      |> Enum.into(@create_attrs)
      |> Notes.create_note()

    note
  end

  setup %{conn: conn} do
    user = user_fixture()

    token = Phoenix.Token.sign(NotexWeb.Endpoint, "user_id", user.id)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all note", %{conn: conn} do
      conn = get(conn, Routes.note_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create note" do
    test "renders note when data is valid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some content",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update note" do
    setup [:create_note]

    test "renders note when data is valid", %{conn: conn, note: %Note{id: id} = note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some updated content",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, note: note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete note" do
    setup [:create_note]

    test "deletes chosen note", %{conn: conn, note: note} do
      conn = delete(conn, Routes.note_path(conn, :delete, note))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.note_path(conn, :show, note))
      end
    end
  end

  defp create_note(%{user: user}) do
    note = note_fixture(%{user_id: user.id})
    {:ok, note: note}
  end
end
