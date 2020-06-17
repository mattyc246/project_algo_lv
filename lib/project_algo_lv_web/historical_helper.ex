defmodule ProjectAlgoLvWeb.HistoricalHelper do
  alias ProjectAlgoLvWeb.DynamoHelper

  def get_account_records(acc_id) do
    data = get_data()
    # Create a list of all the records for a specific account
    Enum.reduce(data, [], fn hd, acc ->
      if hd.account_id == acc_id, do: [hd | acc], else: acc
    end)
  end

  def get_strategy_balances(token) do
    get_strategy_records(token)
    |> Enum.reduce(%{}, fn hd, acc ->
      Map.put(acc, hd.created_at, hd.margin_balance)
    end)
  end

  def get_strategy_records(token) do
    data = get_data()
    # Create a list of all the records for a specific strategy
    Enum.reduce(data, [], fn hd, acc ->
      if hd.strategy_access_token == token, do: [Map.from_struct(hd) | acc], else: acc
    end)
    |> Enum.sort_by(&(&1.created_at), :desc)
    |> Enum.slice(0, 50)
  end

  def hourly_wallet_balance(accounts) do
    data = last_day_records(accounts)
    hour_range = get_hours(DateTime.utc_now.hour, 24)
    Map.to_list(Enum.reduce(accounts, %{}, fn account, acc_dt ->
      last_record = last_account_record(account, data)
      if last_record do
        datas_for_acc = Enum.reduce(data, [], fn hd, acc ->
          if hd.account_id == account, do: [hd | acc], else: acc
        end)
        |> Enum.sort_by(&(&1.created_at), :desc)
        account_data = Enum.reduce(hour_range, %{}, fn hour, acc ->
          result = Enum.find(datas_for_acc, fn hd ->
            {:ok, dt, _} = DateTime.from_iso8601(hd.created_at)
            hour == dt.hour
          end)
          if result do
            Map.put(acc, Integer.to_string(hour), result)
          else
            prev_idx = Enum.find_index(hour_range, fn hr -> hr == hour end) - 1
            if prev_idx >= 0 do
              Map.put(acc, Integer.to_string(hour), acc[Integer.to_string(Enum.at(hour_range, prev_idx))])
            else
              Map.put(acc, Integer.to_string(hour), last_record)
            end
          end
        end)
        Map.put(acc_dt, Integer.to_string(account), account_data)
      else
        acc_dt
      end
    end))
    |> Enum.reduce(%{}, fn {_, acc_data}, acc ->
      Map.to_list(acc_data)
      |> Enum.reduce(acc, fn {hr, dt}, accum ->
        Map.update(accum, hr, dt.wallet_balance, &(&1 + dt.wallet_balance))
      end)
    end)
    |> Map.update("hour_range", hour_range, &(&1))
  end

  def daily_first_last(accounts) do
    data = hourly_wallet_balance(accounts)
    %{
      first: data[Integer.to_string(Enum.at(data["hour_range"], 0))],
      last: data[Integer.to_string(Enum.at(data["hour_range"], Enum.count(data["hour_range"]) - 1))]
    }
  end

  def last_day_records(accounts) do
    data = get_data()
    # Create a list of the last 24hours of records for all accounts
    now = DateTime.add(DateTime.utc_now, -86400, :second)
    # DateTime.compare()
    Enum.reduce(data, [], fn hd, acc ->
      {:ok, converted_time, _} = DateTime.from_iso8601(hd.created_at)
      if (DateTime.compare(converted_time, now) == :gt) && Enum.member?(accounts, hd.account_id) do
        [hd | acc]
      else
        acc
      end
    end)
  end

  def last_account_record(account_id, data) do
    Enum.sort_by(data, &(&1.created_at), :desc)
    |> Enum.find(fn hd -> hd.account_id == account_id end)
  end

  def last_created_records(accounts) do
    data = get_data()
    # Create a list of the last record for each account
    sorted =
      Enum.sort_by(data, &(&1.created_at), :desc)
    Enum.reduce(accounts, [], fn id, acc ->
      record = Enum.find(sorted, fn hd -> hd.account_id == id end)
      if record, do: [record | acc], else: acc
    end)
  end

  def combined_account_balance(accounts) do
      data = last_created_records(accounts)
      # Needs to take in a list of %HistoricalData{} with last record for each strategy
      Enum.reduce(data, [], fn hd, acc -> [hd.wallet_balance | acc] end)
      |> Enum.sum()
  end

  defp get_data do
    DynamoHelper.fetch_all_data
  end

  defp get_hours(start, range, acc \\ []) do
    if range != 0 do
      if start == 24 do
        start = 0
        get_hours(start + 1, range - 1, [0 | acc])
      else
        get_hours(start + 1, range - 1, [start | acc])
      end
    else
      Enum.reverse(acc)
    end
  end

end