defmodule Pickup.Draw do
  def center(content, size, options \\ []) do
    defaults = [spacer: " ", prefix: "", suffix: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    if String.length(options.spacer) != 1, do: raise("Spacer must be 1 character")

    padding_spaces =
      size - String.length(content) - String.length(options.prefix) -
        String.length(options.suffix)

    padded_content =
      Enum.reduce(1..padding_spaces, content, fn i, padded ->
        if rem(i, 2) == 0, do: options.spacer <> padded, else: padded <> options.spacer
      end)

    [
      options.prefix,
      padded_content,
      options.suffix
    ]
    |> Enum.join("")
  end

  def separator(spacer \\ " ", size) do
    String.duplicate(spacer, size)
  end

  def line(left, right \\ "", size, filler \\ " ") do
    [
      left,
      String.duplicate(filler, size - String.length(left) - String.length(right)),
      right
    ]
    |> Enum.join("")
  end

  def fitted(content, space) do
    if String.length(content) > space do
      content
      |> String.slice(0..(space - 2))
      |> String.trim_trailing()
      |> Kernel.<>("…")
    else
      content
    end
  end

  def blockquote(content, size, options \\ []) do
    defaults = [prefix: ""]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    content
    |> String.to_charlist()
    |> Enum.chunk_every(size - String.length(options.prefix))
    |> Enum.map(&to_string(&1))
    |> Enum.map(&(options.prefix <> &1 <> "\n"))
    |> Enum.join("")
    |> String.trim()
  end

  def codeblock(content) do
    "```\n" <> content <> "\n```"
  end
end
