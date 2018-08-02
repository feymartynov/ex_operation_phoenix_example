defmodule AppWeb.SimpleFormatHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Tag

  def simple_format(string, opts \\ []) do
    escape? = Keyword.get(opts, :escape, true)
    wrapper_tag = Keyword.get(opts, :wrapper_tag, :p)
    attributes = Keyword.get(opts, :attributes, [])

    string
    |> maybe_html_escape_to_string(escape?)
    |> String.split("\n\n", trim: true)
    |> Stream.filter(&not_blank?/1)
    |> Stream.map(&wrap_paragraph(&1, wrapper_tag, attributes))
    |> Enum.to_list()
    |> raw()
  end

  defp maybe_html_escape_to_string(string, true), do: string |> html_escape() |> safe_to_string()
  defp maybe_html_escape_to_string(string, false), do: string

  defp not_blank?(" " <> rest), do: not_blank?(rest)
  defp not_blank?("\n" <> rest), do: not_blank?(rest)
  defp not_blank?(""), do: false
  defp not_blank?(_), do: true

  defp wrap_paragraph(text, tag, attributes) do
    broken_text = insert_brs(text)
    {:safe, data} = content_tag(tag, broken_text, attributes)
    [data, ?\n]
  end

  defp insert_brs(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.intersperse(["<br />", ?\n])
    |> raw
  end
end
