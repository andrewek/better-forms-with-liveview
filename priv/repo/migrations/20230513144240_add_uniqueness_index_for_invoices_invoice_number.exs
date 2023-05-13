defmodule BetterForms.Repo.Migrations.AddUniquenessIndexForInvoicesInvoiceNumber do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    drop index(:invoices, :invoice_number)
    create unique_index(:invoices, :invoice_number, [concurrently: true])
  end
end
