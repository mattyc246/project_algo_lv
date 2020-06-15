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
end
