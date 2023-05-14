defmodule BetterForms.Invoices.Queries do
  @moduledoc """
  Composable Invoice queries
  """

  alias BetterForms.Invoices.Invoice
  import Ecto.Query

  def base_query() do
    Invoice
  end

  def by_invoice_number(queryable, invoice_number) do
    from invoice in queryable,
      where: invoice.invoice_number == ^invoice_number
  end
end
