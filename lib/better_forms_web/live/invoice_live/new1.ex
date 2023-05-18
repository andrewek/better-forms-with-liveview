defmodule BetterFormsWeb.InvoiceLive.New1 do
  @moduledoc """
  First example for form validation patterns.

  Problems:

  + Feedback not near form field
  + Feedback only on submit
  + Not using HTML attributes to control form
  """

  use BetterFormsWeb, :live_view
  import Phoenix.HTML.Form

  alias BetterForms.Invoices.Context, as: InvoiceContext
  alias BetterForms.Invoices.Invoice

  def mount(_params, _session, socket) do
    changeset =
      %{}
      |> InvoiceContext.creation_changeset()

    status_options = InvoiceContext.status_options()

    socket
    |> assign(page_title: "New Invoice - 1")
    |> assign(changeset: changeset)
    |> assign(status_options: status_options)
    |> then(&{:ok, &1})
  end

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

  @doc """
  A helper that transforms changeset errors into an array of humanized messages

  We're only using it here for demonstration porpoises. In all other cases we
  want the error message to be MUCH closer to the input.
  """
  def full_errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
    |> Enum.flat_map(fn {key, errors} ->
      Enum.map(
        errors,
        fn error -> "#{humanize(key)} #{error}" |> String.capitalize() end
      )
    end)
  end
end
