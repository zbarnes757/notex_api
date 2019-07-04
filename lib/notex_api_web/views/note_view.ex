defmodule NotexWeb.NoteView do
  use NotexWeb, :view
  alias NotexWeb.NoteView

  def render("index.json", %{note: note}) do
    %{data: render_many(note, NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{id: note.id,
      title: note.title,
      content: note.content}
  end
end
