defmodule BetterForms.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: BetterForms.Repo

  def invoice_factory do
    %BetterForms.Invoices.Invoice{
      amount_in_cents: Enum.random(1111..99_999),
      description: "This is a description I guess?",
      due_on: ~D[2023-07-19],
      invoice_number: sequence(:invoice_number, & &1, start_at: 1000),
      recipient_email: sequence(:recipient_email, &"email-#{&1}@some-email.com"),
      status: :open
    }
  end
end
