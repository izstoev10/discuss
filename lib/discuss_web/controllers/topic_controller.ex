defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics.Topic
  alias Discuss.Topics

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :new, changeset: changeset)
  end

  def index(conn, _params) do
    topics = Topics.list_topics()
    render(conn, :index, topics: topics)
  end

  def create(conn, %{"topic" => topic} = params) do
    case Topics.create_topic(topic) do
      {:ok, post} -> IO.inspect(post)
      {:error, changeset} -> render(conn, :new, changeset: changeset)
    end
  end
end
