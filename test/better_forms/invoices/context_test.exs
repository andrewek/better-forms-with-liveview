defmodule BetterForms.Invoices.ContextTest do
  use BetterForms.DataCase, async: true

  import BetterForms.Factory

  alias BetterForms.Invoices.Context, as: InvoiceContext
  alias BetterForms.Invoices.Invoice

  describe "recommended_invoice_number/0" do
    test "gives you a starting number with stuff in the DB" do
      [1, 897, 745]
      |> Enum.each(&insert(:invoice, invoice_number: &1))

      assert 898 == InvoiceContext.recommended_invoice_number()
    end

    test "starts at 1 with nothing in the DB" do
      assert 1 == InvoiceContext.recommended_invoice_number()
    end
  end

  describe "get/1" do
    test "fetches it if exists" do
      %Invoice{id: id} = insert(:invoice)

      assert {:ok, %Invoice{id: ^id}} = InvoiceContext.get(id)
    end

    test "fails if it doesn't" do
      id = Ecto.UUID.generate()
      assert {:error, Invoice, :not_found} = InvoiceContext.get(id)
    end
  end

  describe "get_by_invoice_number/1" do
    test "fetches if it exists" do
      %Invoice{id: id, invoice_number: num} = insert(:invoice)

      assert {:ok, %Invoice{id: ^id, invoice_number: ^num}} =
               InvoiceContext.get_by_invoice_number(num)
    end

    test "returns error if it doesn't" do
      assert {:error, Invoice, :not_found} = InvoiceContext.get_by_invoice_number(0)
    end
  end

  describe "insert/1" do
    setup do
      invoice_attrs =
        build(:invoice)
        |> Map.from_struct()
        |> Map.drop([:__meta__])

      %{invoice_attrs: invoice_attrs}
    end

    test "creates", %{invoice_attrs: attrs} do
      changeset = Invoice.create_changeset(attrs)

      assert {:ok, %Invoice{}} = InvoiceContext.insert(changeset)
    end

    test "returns with errors", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:amount_in_cents, -1)
        |> Invoice.create_changeset()

      assert {:error, _changeset} = InvoiceContext.insert(changeset)
    end
  end
end
