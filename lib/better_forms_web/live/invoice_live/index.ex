defmodule BetterFormsWeb.InvoiceLive.Index do
  use BetterFormsWeb, :live_view

  alias BetterForms.Invoices.Context, as: InvoiceContext

  @impl true
  def mount(_params, _session, socket) do
    invoices = InvoiceContext.all()

    socket
    |> assign(invoices: invoices)
    |> then(&{:ok, &1})
  end
end
