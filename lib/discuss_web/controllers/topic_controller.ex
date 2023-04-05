defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics.Topic
  alias Discuss.Topics
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :new, changeset: changeset)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Topics.get_topic!(topic_id)
    changeset = Topic.changeset(topic, %{})
    render(conn, :edit, changeset: changeset, topic: topic, topic_id: topic.id)
  end

  def update(conn, %{"topic_id" => id, "topic" => topic}) do
    old_topic = Topics.get_topic!(id)

    case Topics.update_topic(old_topic, topic) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: DiscussWeb.Router.Helpers.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  def index(conn, _params) do
    topics = Topics.list_topics()
    render(conn, :index, topics: topics)
  end

  def delete(conn, %{"id" => id}) do
    Topics.get_topic!(id) |> Topics.delete_topic!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: DiscussWeb.Router.Helpers.topic_path(conn, :index))
  end

  def create(conn, %{"topic" => topic}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: DiscussWeb.Router.Helpers.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
