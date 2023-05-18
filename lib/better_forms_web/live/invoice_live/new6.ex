defmodule BetterFormsWeb.InvoiceLive.New6 do
  @moduledoc """
  Sixth example of form validation patterns

  Relative to V5 we:

  + Have a much more pleasant amount_in_dollars experience

  Issues we still have:

  + Line Items don't yet exist
  """

  use BetterFormsWeb, :live_view

  alias BetterForms.Invoices.Context, as: InvoiceContext
  alias BetterForms.Invoices.Invoice, as: Invoice

  @impl true
  def mount(_params, _session, socket) do
    form =
      %{}
      |> Map.put(:invoice_number, InvoiceContext.recommended_invoice_number())
      |> InvoiceContext.creation_with_dollars_changeset()
      |> to_form()

    status_options = InvoiceContext.status_options()

    socket
    |> assign(page_title: "New Invoice - 6")
    |> assign(form: form)
    |> assign(status_options: status_options)
    |> then(&{:ok, &1})
  end

  @impl true
  def handle_event("save", %{"invoice" => invoice_params}, socket) do
    changeset =
      invoice_params
      |> InvoiceContext.creation_with_dollars_changeset()

    result = InvoiceContext.insert(changeset)

    case result do
      {:ok, %Invoice{invoice_number: number}} ->
        socket
        |> put_flash(:success, "Created invoice ##{number}!")
        |> push_redirect(to: ~p"/invoices")
        |> then(&{:noreply, &1})

      {:error, changeset} ->
        form = to_form(changeset)

        socket
        |> put_flash(:error, "Something went wrong!")
        |> assign(form: form)
        |> then(&{:noreply, &1})
    end
  end

  def handle_event("validate", %{"invoice" => invoice_params}, socket) do
    form =
      invoice_params
      |> InvoiceContext.creation_changeset()
      |> Map.put(:action, :validate)
      |> to_form()

    socket
    |> assign(form: form)
    |> then(&{:noreply, &1})
  end
end
