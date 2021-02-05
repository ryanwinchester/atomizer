defmodule AtomizerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AtomizerWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import AtomizerWeb.ConnCase

      alias AtomizerWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AtomizerWeb.Endpoint
    end
  end

  @doc """
  Asserts the given status code, that we have an html response and
  returns the response body if one was set or sent.

  ## Examples

      assert html_response(conn, 200) =~ "<html>"
  """
  @spec xml_response(Conn.t(), status :: integer | atom) :: String.t() | no_return
  def xml_response(conn, status) do
    body = Phoenix.ConnTest.response(conn, status)
    _ = Phoenix.ConnTest.response_content_type(conn, :xml)
    body
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
