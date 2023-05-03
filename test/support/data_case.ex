defmodule BetterForms.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BetterForms.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias BetterForms.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import BetterForms.DataCase
    end
  end

  setup tags do
    BetterForms.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(BetterForms.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @doc """
  This helper makes life just a little easier when setting up test datetimes

  Invoke like so:

      time_from_now([months: 19, minutes: 7])
      time_from_now([days: -3])
      time_from_now([hours: 12, minutes: 2])

  These will give you (respectively:

  + 19 months and 7 minutes into the future from now
  + 3 days ago
  + 12 hours from now, minus 2 minutes (or 11 hours, 58 minutes)
  """
  def time_from_now(attrs) do
    Timex.now()
    |> Timex.shift(attrs)
  end

  @doc """
  This helper makes life just a little easier when setting up test dates

  Invoke like so:

      date_from_now([months: 19, minutes: 7])
      date_from_now([days: -3])
      date_from_now([hours: 12, minutes: 2])

  These will give you (respectively:

  + 19 months and 7 minutes into the future from now
  + 3 days ago
  + 12 hours from now, minus 2 minutes (or 11 hours, 58 minutes)

  Except all will come back as a date rather than a DateTime.
  """
  def date_from_now(attrs) do
    time_from_now(attrs)
    |> Timex.to_date()
  end
end
