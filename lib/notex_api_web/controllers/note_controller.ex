defmodule NotexWeb.NoteController do
  use NotexWeb, :controller

  alias Notex.Notes
  alias Notex.Notes.Note

  plug NotexWeb.AuthPlug

  action_fallback NotexWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.private[:user_id]
    note = Notes.list_note(filter: %{user_id: user_id})
    render(conn, "index.json", note: note)
  end

  def create(conn, %{"note" => note_params}) do
    with user_id = conn.private[:user_id],
         note_params = Map.put(note_params, "user_id", user_id),
         {:ok, %Note{} = note} <-
           Notes.create_note(note_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.note_path(conn, :show, note))
      |> render("show.json", note: note)
    end
  end

  def show(conn, %{"id" => id}) do
    with user_id = conn.private[:user_id],
         {:ok, note} <- Notes.get_note(id, filter: %{user_id: user_id}) do
      render(conn, "show.json", note: note)
    end
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    with user_id = conn.private[:user_id],
         {:ok, note} <- Notes.get_note(id, filter: %{user_id: user_id}),
         {:ok, %Note{} = note} <- Notes.update_note(note, note_params) do
      render(conn, "show.json", note: note)
    end
  end

  def delete(conn, %{"id" => id}) do
    with user_id = conn.private[:user_id],
         {:ok, note} <- Notes.get_note(id, filter: %{user_id: user_id}),
         {:ok, %Note{}} <- Notes.delete_note(note) do
      send_resp(conn, :no_content, "")
    end
  end
end
