defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics.Topic

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :new, changeset: changeset)
  end
end
