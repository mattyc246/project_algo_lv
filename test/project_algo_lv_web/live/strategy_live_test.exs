defmodule ProjectAlgoLvWeb.StrategyLiveTest do
  use ProjectAlgoLvWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ProjectAlgoLv.Trades

  @create_attrs %{access_token: "some access_token", description: "some description", name: "some name"}
  @update_attrs %{access_token: "some updated access_token", description: "some updated description", name: "some updated name"}
  @invalid_attrs %{access_token: nil, description: nil, name: nil}

  defp fixture(:strategy) do
    {:ok, strategy} = Trades.create_strategy(@create_attrs)
    strategy
  end

  defp create_strategy(_) do
    strategy = fixture(:strategy)
    %{strategy: strategy}
  end

  describe "Index" do
    setup [:create_strategy]

    test "lists all strategies", %{conn: conn, strategy: strategy} do
      {:ok, _index_live, html} = live(conn, Routes.strategy_index_path(conn, :index))

      assert html =~ "Listing Strategies"
      assert html =~ strategy.access_token
    end

    test "saves new strategy", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.strategy_index_path(conn, :index))

      assert index_live |> element("a", "New Strategy") |> render_click() =~
               "New Strategy"

      assert_patch(index_live, Routes.strategy_index_path(conn, :new))

      assert index_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#strategy-form", strategy: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.strategy_index_path(conn, :index))

      assert html =~ "Strategy created successfully"
      assert html =~ "some access_token"
    end

    test "updates strategy in listing", %{conn: conn, strategy: strategy} do
      {:ok, index_live, _html} = live(conn, Routes.strategy_index_path(conn, :index))

      assert index_live |> element("#strategy-#{strategy.id} a", "Edit") |> render_click() =~
               "Edit Strategy"

      assert_patch(index_live, Routes.strategy_index_path(conn, :edit, strategy))

      assert index_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#strategy-form", strategy: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.strategy_index_path(conn, :index))

      assert html =~ "Strategy updated successfully"
      assert html =~ "some updated access_token"
    end

    test "deletes strategy in listing", %{conn: conn, strategy: strategy} do
      {:ok, index_live, _html} = live(conn, Routes.strategy_index_path(conn, :index))

      assert index_live |> element("#strategy-#{strategy.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#strategy-#{strategy.id}")
    end
  end

  describe "Show" do
    setup [:create_strategy]

    test "displays strategy", %{conn: conn, strategy: strategy} do
      {:ok, _show_live, html} = live(conn, Routes.strategy_show_path(conn, :show, strategy))

      assert html =~ "Show Strategy"
      assert html =~ strategy.access_token
    end

    test "updates strategy within modal", %{conn: conn, strategy: strategy} do
      {:ok, show_live, _html} = live(conn, Routes.strategy_show_path(conn, :show, strategy))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Strategy"

      assert_patch(show_live, Routes.strategy_show_path(conn, :edit, strategy))

      assert show_live
             |> form("#strategy-form", strategy: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#strategy-form", strategy: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.strategy_show_path(conn, :show, strategy))

      assert html =~ "Strategy updated successfully"
      assert html =~ "some updated access_token"
    end
  end
end
