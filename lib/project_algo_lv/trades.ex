defmodule ProjectAlgoLv.Trades do
  @moduledoc """
  The Trades context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias ProjectAlgoLv.Repo
  alias ProjectAlgoLv.Accounts.User

  alias ProjectAlgoLv.Trades.Strategy

  @doc """
  Returns the list of strategies.

  ## Examples

      iex> list_strategies()
      [%Strategy{}, ...]

  """
  def list_strategies do
    Repo.all(Strategy)
  end

  def list_user_strategies(%User{} = user) do
    from(s in Strategy, where: s.user_id == ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single strategy.

  Raises `Ecto.NoResultsError` if the Strategy does not exist.

  ## Examples

      iex> get_strategy!(123)
      %Strategy{}

      iex> get_strategy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_strategy!(id), do: Repo.get!(Strategy, id)

  @doc """
  Creates a strategy.

  ## Examples

      iex> create_strategy(%{field: value})
      {:ok, %Strategy{}}

      iex> create_strategy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_strategy(%User{} = user, attrs \\ %{}) do
    %Strategy{}
    |> Strategy.changeset(attrs)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a strategy.

  ## Examples

      iex> update_strategy(strategy, %{field: new_value})
      {:ok, %Strategy{}}

      iex> update_strategy(strategy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_strategy(%Strategy{} = strategy, attrs) do
    strategy
    |> Strategy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a strategy.

  ## Examples

      iex> delete_strategy(strategy)
      {:ok, %Strategy{}}

      iex> delete_strategy(strategy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_strategy(%Strategy{} = strategy) do
    Repo.delete(strategy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking strategy changes.

  ## Examples

      iex> change_strategy(strategy)
      %Ecto.Changeset{data: %Strategy{}}

  """
  def change_strategy(%Strategy{} = strategy, attrs \\ %{}) do
    Strategy.changeset(strategy, attrs)
  end

  alias ProjectAlgoLv.Trades.TradeAccount

  @doc """
  Returns the list of trade_accounts.

  ## Examples

      iex> list_trade_accounts()
      [%TradeAccount{}, ...]

  """
  def list_trade_accounts do
    Repo.all(TradeAccount)
  end

  @doc """
  Gets a single trade_account.

  Raises `Ecto.NoResultsError` if the Trade account does not exist.

  ## Examples

      iex> get_trade_account!(123)
      %TradeAccount{}

      iex> get_trade_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trade_account!(id), do: Repo.get!(TradeAccount, id)

  @doc """
  Creates a trade_account.

  ## Examples

      iex> create_trade_account(%{field: value})
      {:ok, %TradeAccount{}}

      iex> create_trade_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trade_account(attrs \\ %{}) do
    %TradeAccount{}
    |> TradeAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trade_account.

  ## Examples

      iex> update_trade_account(trade_account, %{field: new_value})
      {:ok, %TradeAccount{}}

      iex> update_trade_account(trade_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trade_account(%TradeAccount{} = trade_account, attrs) do
    trade_account
    |> TradeAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trade_account.

  ## Examples

      iex> delete_trade_account(trade_account)
      {:ok, %TradeAccount{}}

      iex> delete_trade_account(trade_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trade_account(%TradeAccount{} = trade_account) do
    Repo.delete(trade_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trade_account changes.

  ## Examples

      iex> change_trade_account(trade_account)
      %Ecto.Changeset{data: %TradeAccount{}}

  """
  def change_trade_account(%TradeAccount{} = trade_account, attrs \\ %{}) do
    TradeAccount.changeset(trade_account, attrs)
  end
end
