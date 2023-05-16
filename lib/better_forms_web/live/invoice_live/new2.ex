defmodule BetterFormsWeb.InvoiceLive.New2 do
  @moduledoc """
  Second example of form validation patterns

  Relative to V1, we:

  + Show errors close to form element

  We still have problems of:

  + Dev experience is clunky
  + Only see validations on submit
  + Form doesn't handle disconnects with any grace
  """

  use BetterFormsWeb, :live_view
  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  alias BetterForms.Invoices.Context, as: InvoiceContext
  alias BetterForms.Invoices.Invoice, as: Invoice

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      %{}
      |> Map.put(:invoice_number, InvoiceContext.recommended_invoice_number())
      |> InvoiceContext.creation_changeset()

    status_options = InvoiceContext.status_options()

    socket
    |> assign(page_title: "New Invoice - 2")
    |> assign(changeset: changeset)
    |> assign(status_options: status_options)
    |> then(&{:ok, &1})
  end

  @impl true
  def handle_event("save", %{"invoice" => invoice_params}, socket) do
    changeset =
      invoice_params
      |> InvoiceContext.creation_changeset()

    result = InvoiceContext.insert(changeset)

    case result do
      {:ok, %Invoice{invoice_number: number}} ->
        socket
        |> put_flash(:success, "Created invoice ##{number}!")
        |> push_redirect(to: ~p"/invoices")
        |> then(&{:noreply, &1})

      {:error, changeset} ->
        socket
        |> put_flash(:error, "Something went wrong!")
        |> assign(changeset: changeset)
        |> then(&{:noreply, &1})
    end
  end

  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "text-red-500"
    end
  end
end
