defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel("comments:*", DiscussWeb.CommentsChannel)

  def connect(params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, params["user_id"])}
  end

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
