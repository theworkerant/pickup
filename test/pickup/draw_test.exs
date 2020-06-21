defmodule Pickup.DrawTest do
  use Pickup.DataCase

  alias Pickup.{Draw}

  test "centers some text" do
    assert Draw.center("Ensy", 10) == "   Ensy   "
  end

  test "bad spacer" do
    assert_raise(RuntimeError, fn ->
      Draw.center("Ensy", 10, spacer: "way too long!")
    end)
  end

  test "centers some uneven" do
    size = 9
    result = Draw.center("Ensy", 9)
    assert result == "  Ensy   "
    assert String.length(result) == size
  end

  test "centers some text with prefix" do
    size = 16
    result = Draw.center("Ergle", size, prefix: "!")
    assert result == "!     Ergle     "
    assert String.length(result) == size
  end

  test "centers some text with suffix" do
    size = 10
    result = Draw.center("Ensy", 10, suffix: "!")
    assert result == "  Ensy   !"
    assert String.length(result) == size
  end

  test "centers some text with prefix & suffix" do
    size = 10
    result = Draw.center("Ensy", size, prefix: "!", suffix: "!")
    assert result == "!  Ensy  !"
    assert String.length(result) == size
  end

  test "players bar thing" do
    assert Draw.center(" PLAYERS ", 49, spacer: "=") ==
             "==================== PLAYERS ===================="
  end

  test "empty spacer line" do
    assert Draw.separator(10) == "          "
  end

  test "full spacer line" do
    assert Draw.separator("=", 10) == "=========="
  end

  test "normal line of text" do
    assert Draw.line("GL HF DD", 10) == "GL HF DD  "
  end

  test "line with left and right" do
    assert Draw.line("Winner ", " Ensy", 20) == "Winner          Ensy"
  end

  test "line with left, right, and filler" do
    assert Draw.line("Winner ", " Ensy", 20, ".") == "Winner ........ Ensy"
  end

  test "fitted text" do
    assert Draw.fitted("Nebuchadnezzar", 10) == "Nebuchadn…"
    # Trailing spaces dropped
    assert Draw.fitted("Nebuchadnezzar The First", 15) == "Nebuchadnezzar…"
    assert Draw.fitted("Nebuchadnezzar The First", 16) == "Nebuchadnezzar…"
  end

  test "fitted and centered text" do
    assert Draw.fitted("Nebuchadnezzar", 10) |> Draw.center(12) == " Nebuchadn… "
  end

  test "Blockquote content" do
    blockquote = "Let's battle and hope we don't get team switched or headshot by hackers."

    assert Draw.blockquote(blockquote, 49) ==
             "Let's battle and hope we don't get team switched \nor headshot by hackers."
  end

  test "Quoted content with prefix" do
    blockquote = "Let's battle and hope we don't get team switched or headshot by hackers."

    assert Draw.blockquote(blockquote, 49, prefix: "> ") ==
             "> Let's battle and hope we don't get team switche\n> d or headshot by hackers."
  end

  test "Codeblock" do
    content = "This is a codeblock"
    assert Draw.codeblock(content) == "```\nThis is a codeblock\n```"
  end
end
