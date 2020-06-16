defmodule ProjectAlgoLvWeb.TradeAccountLiveTest do
  use ProjectAlgoLvWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ProjectAlgoLv.Trades

  @create_attrs %{name: "some name", platform: "some platform"}
  @update_attrs %{name: "some updated name", platform: "some updated platform"}
  @invalid_attrs %{name: nil, platform: nil}

  defp fixture(:trade_account) do
    {:ok, trade_account} = Trades.create_trade_account(@create_attrs)
    trade_account
  end

  defp create_trade_account(_) do
    trade_account = fixture(:trade_account)
    %{trade_account: trade_account}
  end

  describe "Index" do
    setup [:create_trade_account]

    test "lists all trade_accounts", %{conn: conn, trade_account: trade_account} do
      {:ok, _index_live, html} = live(conn, Routes.trade_account_index_path(conn, :index))

      assert html =~ "Listing Trade accounts"
      assert html =~ trade_account.name
    end

    test "saves new trade_account", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.trade_account_index_path(conn, :index))

      assert index_live |> element("a", "New Trade account") |> render_click() =~
               "New Trade account"

      assert_patch(index_live, Routes.trade_account_index_path(conn, :new))

      assert index_live
             |> form("#trade_account-form", trade_account: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#trade_account-form", trade_account: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trade_account_index_path(conn, :index))

      assert html =~ "Trade account created successfully"
      assert html =~ "some name"
    end

    test "updates trade_account in listing", %{conn: conn, trade_account: trade_account} do
      {:ok, index_live, _html} = live(conn, Routes.trade_account_index_path(conn, :index))

      assert index_live |> element("#trade_account-#{trade_account.id} a", "Edit") |> render_click() =~
               "Edit Trade account"

      assert_patch(index_live, Routes.trade_account_index_path(conn, :edit, trade_account))

      assert index_live
             |> form("#trade_account-form", trade_account: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#trade_account-form", trade_account: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trade_account_index_path(conn, :index))

      assert html =~ "Trade account updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes trade_account in listing", %{conn: conn, trade_account: trade_account} do
      {:ok, index_live, _html} = live(conn, Routes.trade_account_index_path(conn, :index))

      assert index_live |> element("#trade_account-#{trade_account.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#trade_account-#{trade_account.id}")
    end
  end

  describe "Show" do
    setup [:create_trade_account]

    test "displays trade_account", %{conn: conn, trade_account: trade_account} do
      {:ok, _show_live, html} = live(conn, Routes.trade_account_show_path(conn, :show, trade_account))

      assert html =~ "Show Trade account"
      assert html =~ trade_account.name
    end

    test "updates trade_account within modal", %{conn: conn, trade_account: trade_account} do
      {:ok, show_live, _html} = live(conn, Routes.trade_account_show_path(conn, :show, trade_account))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Trade account"

      assert_patch(show_live, Routes.trade_account_show_path(conn, :edit, trade_account))

      assert show_live
             |> form("#trade_account-form", trade_account: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#trade_account-form", trade_account: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trade_account_show_path(conn, :show, trade_account))

      assert html =~ "Trade account updated successfully"
      assert html =~ "some updated name"
    end
  end
end
