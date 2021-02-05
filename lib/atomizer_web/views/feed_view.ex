defmodule AtomizerWeb.FeedView do
  use AtomizerWeb, :view

  alias Atomizer.Episode
  alias Atomizer.Show

  def updated_iso8601(%Show{} = show) do
    show.episodes
    |> List.first()
    |> updated_iso8601()
  end

  def updated_iso8601(%Episode{timestamp: timestamp}) do
    updated_iso8601(timestamp)
  end

  def updated_iso8601(datetime) when is_binary(datetime) do
    with {:ok, dt, 0} <- DateTime.from_iso8601(datetime) do
      DateTime.to_iso8601(dt)
    end
  end

  def xml_escape(data) when is_binary(data) do
    data
    |> xml_escape_string()
    |> to_string()
  end

  def xml_escape(data) when not is_bitstring(data) do
    data
    |> to_string()
    |> xml_escape_string()
    |> to_string()
  end

  def xml_escape_string(""), do: ""
  def xml_escape_string(<<"&"::utf8, rest::binary>>), do: xml_escape_entity(rest)
  def xml_escape_string(<<"<"::utf8, rest::binary>>), do: ["&lt;" | xml_escape_string(rest)]
  def xml_escape_string(<<">"::utf8, rest::binary>>), do: ["&gt;" | xml_escape_string(rest)]
  def xml_escape_string(<<"\""::utf8, rest::binary>>), do: ["&quot;" | xml_escape_string(rest)]
  def xml_escape_string(<<"'"::utf8, rest::binary>>), do: ["&apos;" | xml_escape_string(rest)]
  def xml_escape_string(<<c::utf8, rest::binary>>), do: [c | xml_escape_string(rest)]

  def xml_escape_entity(<<"amp;"::utf8, rest::binary>>), do: ["&amp;" | xml_escape_string(rest)]
  def xml_escape_entity(<<"lt;"::utf8, rest::binary>>), do: ["&lt;" | xml_escape_string(rest)]
  def xml_escape_entity(<<"gt;"::utf8, rest::binary>>), do: ["&gt;" | xml_escape_string(rest)]
  def xml_escape_entity(<<"quot;"::utf8, rest::binary>>), do: ["&quot;" | xml_escape_string(rest)]
  def xml_escape_entity(<<"apos;"::utf8, rest::binary>>), do: ["&apos;" | xml_escape_string(rest)]
  def xml_escape_entity(rest), do: ["&amp;" | xml_escape_string(rest)]
end
