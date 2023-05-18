defmodule BetterFormsWeb.InvoiceLive.Show do
  use BetterFormsWeb, :live_view

  alias BetterForms.Invoices.Context, as: InvoiceContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, invoice} = InvoiceContext.get(id)

    socket
    |> assign(:invoice, invoice)
    |> then(&{:noreply, &1})
  end
end
