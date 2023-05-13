defmodule BetterForms.Invoices.InvoiceTest do
  use BetterForms.DataCase, async: true
  import BetterForms.Factory

  alias BetterForms.Invoices.Invoice

  setup do
    invoice_attrs =
      build(:invoice)
      |> Map.from_struct()
      |> Map.drop([:__meta__])

    %{invoice_attrs: invoice_attrs}
  end

  describe "create_changeset/2" do
    test "requires an amount_in_cents", %{invoice_attrs: invoice_attrs} do
      changeset =
        invoice_attrs
        |> Map.put(:amount_in_cents, nil)
        |> Invoice.create_changeset()

      assert "can't be blank" in errors_on(changeset).amount_in_cents
    end

    test "rejects negative amount_in_cents", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:amount_in_cents, -7)
        |> Invoice.create_changeset()

      assert "must be greater than 0" in errors_on(changeset).amount_in_cents
    end

    test "rejects zero amount_in_cents", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:amount_in_cents, 0)
        |> Invoice.create_changeset()

      assert "must be greater than 0" in errors_on(changeset).amount_in_cents
    end

    test "allows a valid amount_in_cents", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:amount_in_cents, 12_345)
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.amount_in_cents == 12_345
    end

    test "allows a description", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:description, "hi")
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.description == "hi"
    end

    test "allows a nil description", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:description, nil)
        |> Invoice.create_changeset()

      assert changeset.valid?
    end

    test "requires due_on", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:due_on, nil)
        |> Invoice.create_changeset()

      assert "can't be blank" in errors_on(changeset).due_on
    end

    test "requires invoice_number", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:invoice_number, nil)
        |> Invoice.create_changeset()

      assert "can't be blank" in errors_on(changeset).invoice_number
    end

    test "accepts a real invoice number", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:invoice_number, 123_456)
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.invoice_number == 123_456
    end

    test "rejects negative invoice_number", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:invoice_number, -1)
        |> Invoice.create_changeset()

      assert "must be greater than 0" in errors_on(changeset).invoice_number
    end

    test "rejects zero as invoice_number", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:invoice_number, 0)
        |> Invoice.create_changeset()

      assert "must be greater than 0" in errors_on(changeset).invoice_number
    end

    test "requires unique invoice_number", %{invoice_attrs: attrs} do
      number = 12_345

      _old_invoice = insert(:invoice, invoice_number: number)

      changeset =
        attrs
        |> Map.put(:invoice_number, number)
        |> Invoice.create_changeset()

      assert "has already been taken" in errors_on(changeset).invoice_number
    end

    test "accepts a good email", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:recipient_email, "andrew.ek@launchscout.com")
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.recipient_email == "andrew.ek@launchscout.com"
    end

    test "downcases email", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:recipient_email, "ANDREW.EK@LAUNCHSCOUT.COM")
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.recipient_email == "andrew.ek@launchscout.com"
    end

    test "requires recipient_email", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:recipient_email, nil)
        |> Invoice.create_changeset()

      assert "can't be blank" in errors_on(changeset).recipient_email
    end

    test "rejects non-email-formed recipient_email", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:recipient_email, "hi")
        |> Invoice.create_changeset()

      assert "must be a valid email address" in errors_on(changeset).recipient_email
    end

    test "status starts as 'open'", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:status, nil)
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.data.status == :open
    end

    test "allows status override", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:status, :paid)
        |> Invoice.create_changeset()

      assert changeset.valid?
      assert changeset.changes.status == :paid
    end

    test "rejects status override outside of enumerated values", %{invoice_attrs: attrs} do
      changeset =
        attrs
        |> Map.put(:status, :kerflonked)
        |> Invoice.create_changeset()

      refute changeset.valid?
      assert "is invalid" in errors_on(changeset).status
    end
  end
end
