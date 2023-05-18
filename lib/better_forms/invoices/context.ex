defmodule BetterForms.Invoices.Context do
  @moduledoc """
  Convenience Operators
  """

  alias BetterForms.Invoices.Invoice
  alias BetterForms.Invoices.Queries, as: InvoiceQueries
  alias BetterForms.Invoices.Repo, as: InvoiceRepo

  @doc """
  Get all
  """
  def all() do
    InvoiceRepo.all()
  end

  @doc """
  Changeset for Creation
  """
  def creation_changeset(params) do
    Invoice.create_changeset(params)
  end

  @doc """
  Changeset for Creation, but with amount in dollars (as decimal)
  """
  def creation_with_dollars_changeset(params) do
    Invoice.create_with_dollars_changeset(params)
  end

  @doc """
  Get by ID
  """
  def get(id) do
    InvoiceRepo.get(id)
  end

  @doc """
  Fetch by invoice number
  """
  def get_by_invoice_number(number) do
    InvoiceQueries.base_query()
    |> InvoiceQueries.by_invoice_number(number)
    |> InvoiceRepo.one()
  end

  @doc """
  Insert a new record
  """
  def insert(%Ecto.Changeset{} = changeset) do
    InvoiceRepo.insert(changeset)
  end

  @doc """
  Give us a starting invoice number, please!
  """
  def recommended_invoice_number() do
    (InvoiceRepo.max(:invoice_number) || 0) + 1
  end

  @doc """
  Possible Status Values
  """
  def status_options() do
    Ecto.Enum.values(Invoice, :status)
  end
end
