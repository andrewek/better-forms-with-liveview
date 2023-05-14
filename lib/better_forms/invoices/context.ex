defmodule BetterForms.Invoices.Context do
  @moduledoc """
  Convenience Operators
  """

  alias BetterForms.Invoices.Invoice
  alias BetterForms.Invoices.Queries, as: InvoiceQueries
  alias BetterForms.Invoices.Repo, as: InvoiceRepo

  def get_by_invoice_number(number) do
    InvoiceQueries.base_query()
    |> InvoiceQueries.by_invoice_number(number)
    |> InvoiceRepo.one()
  end

  def insert(%Ecto.Changeset{} = changeset) do
    InvoiceRepo.insert(changeset)
  end

  def recommended_invoice_number() do
    (InvoiceRepo.max(:invoice_number) || 0) + 1
  end
end
