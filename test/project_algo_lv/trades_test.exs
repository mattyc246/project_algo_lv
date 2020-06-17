defmodule ProjectAlgoLv.TradesTest do
  use ProjectAlgoLv.DataCase

  alias ProjectAlgoLv.Trades

  describe "strategies" do
    alias ProjectAlgoLv.Trades.Strategy

    @valid_attrs %{access_token: "some access_token", description: "some description", name: "some name"}
    @update_attrs %{access_token: "some updated access_token", description: "some updated description", name: "some updated name"}
    @invalid_attrs %{access_token: nil, description: nil, name: nil}

    def strategy_fixture(attrs \\ %{}) do
      {:ok, strategy} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trades.create_strategy()

      strategy
    end

    test "list_strategies/0 returns all strategies" do
      strategy = strategy_fixture()
      assert Trades.list_strategies() == [strategy]
    end

    test "get_strategy!/1 returns the strategy with given id" do
      strategy = strategy_fixture()
      assert Trades.get_strategy!(strategy.id) == strategy
    end

    test "create_strategy/1 with valid data creates a strategy" do
      assert {:ok, %Strategy{} = strategy} = Trades.create_strategy(@valid_attrs)
      assert strategy.access_token == "some access_token"
      assert strategy.description == "some description"
      assert strategy.name == "some name"
    end

    test "create_strategy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trades.create_strategy(@invalid_attrs)
    end

    test "update_strategy/2 with valid data updates the strategy" do
      strategy = strategy_fixture()
      assert {:ok, %Strategy{} = strategy} = Trades.update_strategy(strategy, @update_attrs)
      assert strategy.access_token == "some updated access_token"
      assert strategy.description == "some updated description"
      assert strategy.name == "some updated name"
    end

    test "update_strategy/2 with invalid data returns error changeset" do
      strategy = strategy_fixture()
      assert {:error, %Ecto.Changeset{}} = Trades.update_strategy(strategy, @invalid_attrs)
      assert strategy == Trades.get_strategy!(strategy.id)
    end

    test "delete_strategy/1 deletes the strategy" do
      strategy = strategy_fixture()
      assert {:ok, %Strategy{}} = Trades.delete_strategy(strategy)
      assert_raise Ecto.NoResultsError, fn -> Trades.get_strategy!(strategy.id) end
    end

    test "change_strategy/1 returns a strategy changeset" do
      strategy = strategy_fixture()
      assert %Ecto.Changeset{} = Trades.change_strategy(strategy)
    end
  end

  describe "trade_accounts" do
    alias ProjectAlgoLv.Trades.TradeAccount

    @valid_attrs %{name: "some name", platform: "some platform"}
    @update_attrs %{name: "some updated name", platform: "some updated platform"}
    @invalid_attrs %{name: nil, platform: nil}

    def trade_account_fixture(attrs \\ %{}) do
      {:ok, trade_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trades.create_trade_account()

      trade_account
    end

    test "list_trade_accounts/0 returns all trade_accounts" do
      trade_account = trade_account_fixture()
      assert Trades.list_trade_accounts() == [trade_account]
    end

    test "get_trade_account!/1 returns the trade_account with given id" do
      trade_account = trade_account_fixture()
      assert Trades.get_trade_account!(trade_account.id) == trade_account
    end

    test "create_trade_account/1 with valid data creates a trade_account" do
      assert {:ok, %TradeAccount{} = trade_account} = Trades.create_trade_account(@valid_attrs)
      assert trade_account.name == "some name"
      assert trade_account.platform == "some platform"
    end

    test "create_trade_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trades.create_trade_account(@invalid_attrs)
    end

    test "update_trade_account/2 with valid data updates the trade_account" do
      trade_account = trade_account_fixture()
      assert {:ok, %TradeAccount{} = trade_account} = Trades.update_trade_account(trade_account, @update_attrs)
      assert trade_account.name == "some updated name"
      assert trade_account.platform == "some updated platform"
    end

    test "update_trade_account/2 with invalid data returns error changeset" do
      trade_account = trade_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Trades.update_trade_account(trade_account, @invalid_attrs)
      assert trade_account == Trades.get_trade_account!(trade_account.id)
    end

    test "delete_trade_account/1 deletes the trade_account" do
      trade_account = trade_account_fixture()
      assert {:ok, %TradeAccount{}} = Trades.delete_trade_account(trade_account)
      assert_raise Ecto.NoResultsError, fn -> Trades.get_trade_account!(trade_account.id) end
    end

    test "change_trade_account/1 returns a trade_account changeset" do
      trade_account = trade_account_fixture()
      assert %Ecto.Changeset{} = Trades.change_trade_account(trade_account)
    end
  end
end
