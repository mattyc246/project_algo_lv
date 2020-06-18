defmodule ProjectAlgoLvWeb.MembershipController do
  use ProjectAlgoLvWeb, :controller

  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Memberships
  alias ProjectAlgoLv.Memberships.Membership
  alias ProjectAlgoLv.Memberships.Transaction

  def new(conn, _params) do
    params = %{
      "price" => 49900,
      "currency" => "usd",
      "title" => "Membership 1 year"
    }
    changeset = Memberships.change_transaction(%Transaction{})
    case create_payment_intent(params) do
      {:ok, client_secret} ->
        render(conn, "new.html", client_secret: client_secret, changeset: changeset)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Please try again later")
        |> redirect(to: Routes.home_path(conn, :index))
    end
  end

  def create(conn, %{"transaction" => transaction_params}) do
    user = conn.assigns.current_user
    transaction_params = Map.put(transaction_params, "billing_details", Jason.decode!(transaction_params["billing_details"]))
    membership_params = %{
      "start_date" => DateTime.utc_now,
      "end_date" =>  DateTime.utc_now |> DateTime.add(60*60*24*365)
    }
    case Memberships.create_membership(user, membership_params) do
      {:ok, membership} ->
        case Memberships.create_transaction(membership, transaction_params) do
          {:ok, _transaction} ->
            conn
            |> put_flash(:info, "Payment success.")
            |> redirect(to: Routes.dashboard_index_path(conn, :index))
          {:error, reason} ->
            conn
            |> put_flash(:error, "Error when creating transaction.")
            |> redirect(to: Routes.membership_path(conn, :new))
        end
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error when creating membership.")
        |> redirect(to: Routes.membership_path(conn, :new))
    end
  end

  defp create_payment_intent(%{"price" => price, "currency" => currency, "title" => description}) do
    params = %{amount: price, currency: currency, description: description, payment_method_types: [:card]}
    case Stripe.PaymentIntent.create(params) do
      {:ok, response} ->
        {:ok, response.client_secret}
      {:error, response} ->
        {:error, response.message}
    end
  end

end