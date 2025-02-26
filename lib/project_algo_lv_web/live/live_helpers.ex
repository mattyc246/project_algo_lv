defmodule ProjectAlgoLvWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias ProjectAlgoLv.Accounts

  @doc """
  Renders a component inside the `ProjectAlgoLvWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ProjectAlgoLvWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, ProjectAlgoLvWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(%{"user_id" => user_id}, socket) do
    socket = assign(socket, current_user: Accounts.get_user_with_membership(user_id))

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/login")
    end
  end
end
