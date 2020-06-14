# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ProjectAlgo.Repo.insert!(%ProjectAlgo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ProjectAlgoLv.Accounts

{:ok, user} = Accounts.create_user(%{
    name: "matthewcross",
    email: "matt@email.com",
    password: "A1234567",
    password_confirmation: "A1234567"
})
