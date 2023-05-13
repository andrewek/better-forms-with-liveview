defmodule Core.Utilities do
  @moduledoc """
  Miscellaneous utilities that don't really fit elsewhere
  """

  @doc """
  This is the W3C-specified regular expression for email input fields.
  """
  def email_regex() do
    Regex.compile!("^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$", [
      :caseless
    ])
  end
end
