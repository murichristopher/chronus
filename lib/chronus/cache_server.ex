defmodule Chronus.CacheServer do
  use GenServer

  @messages_list_key :messages_list

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :ets.new(:messages, [
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, []}
  end

  def put(scheduled_message) do
    GenServer.cast(__MODULE__, {:cache_put, scheduled_message})
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def handle_call({:get}, _from, state) do
    messages_list = current_messages_list()

    {:reply, messages_list, state}
  end

  def handle_cast({:cache_put, scheduled_message}, state) do
    messages_list = get_or_create_messages_list()

    IO.inspect(messages_list, label: "[CURRENT MESSAGES LIST]")

    updated_messages_list = [scheduled_message | messages_list]

    :ets.insert(:messages, {@messages_list_key, updated_messages_list})

    {:noreply, state}
  end

  def current_messages_list do
    :ets.lookup(:messages, @messages_list_key) |> Keyword.get(@messages_list_key)
  end

  defp get_or_create_messages_list() do
    case current_messages_list() do
      nil ->
        :ets.insert(:messages, {@messages_list_key, []})
        []

      messages_list ->
        messages_list
    end
  end
end
