defmodule BetterForms.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :due_on, :date
      add :amount_in_cents, :integer
      add :status, :string
      add :recipient_email, :string
      add :invoice_number, :integer
      add :description, :text

      timestamps()
    end

    create index(:invoices, [:status])
    create index(:invoices, [:recipient_email])
    create index(:invoices, [:invoice_number])
  end
end
