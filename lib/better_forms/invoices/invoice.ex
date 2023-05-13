defmodule BetterForms.Invoices.Invoice do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Core.Utilities, only: [email_regex: 0]

  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "invoices" do
    field :amount_in_cents, :integer
    field :description, :string
    field :due_on, :date
    field :invoice_number, :integer
    field :recipient_email, :string
    field :status, Ecto.Enum, values: [:open, :paid, :canceled], default: :open

    timestamps()
  end

  @doc """
  Changeset for creation of a brand new invoice
  """
  def create_changeset(attrs) do
    %Invoice{}
    |> validate_amount_in_cents(attrs)
    |> validate_description(attrs)
    |> validate_due_on(attrs)
    |> validate_invoice_number(attrs)
    |> validate_recipient_email(attrs)
    |> validate_status(attrs)
  end

  defp validate_amount_in_cents(changeset, attrs) do
    changeset
    |> cast(attrs, [:amount_in_cents])
    |> validate_required([:amount_in_cents])
    |> validate_number(:amount_in_cents, greater_than: 0)
  end

  defp validate_description(changeset, attrs) do
    changeset
    |> cast(attrs, [:description])
  end

  defp validate_due_on(changeset, attrs) do
    changeset
    |> cast(attrs, [:due_on])
    |> validate_required([:due_on])
  end

  defp validate_invoice_number(changeset, attrs) do
    changeset
    |> cast(attrs, [:invoice_number])
    |> validate_required([:invoice_number])
    |> validate_number(:invoice_number, greater_than: 0)
    |> unsafe_validate_unique(:invoice_number, BetterForms.Repo)
  end

  defp validate_recipient_email(changeset, attrs) do
    changeset
    |> cast(attrs, [:recipient_email])
    |> validate_required([:recipient_email])
    |> validate_format(:recipient_email, email_regex(), message: "must be a valid email address")
    |> update_change(:recipient_email, &String.downcase/1)
  end

  defp validate_status(changeset, attrs) do
    changeset
    |> cast(attrs, [:status])
  end
end
