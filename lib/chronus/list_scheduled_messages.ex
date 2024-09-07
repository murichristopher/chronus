defmodule Chronus.ListScheduledMessages do
  alias Chronus.ListScheduledMessages
  alias Chronus.ScheduledMessage

  defstruct auto_id: 1, entries: Map.new()

  def new, do: %ListScheduledMessages{}

  def add_entry(scheduled_messages = %ListScheduledMessages{}, new_entry = %ScheduledMessage{}) do
    %{auto_id: auto_id, entries: entries} = scheduled_messages

    new_entries = Map.put(entries, auto_id, new_entry)

    %ListScheduledMessages{scheduled_messages | entries: new_entries, auto_id: auto_id + 1}
  end

  def update_entry(scheduled_messages = %ListScheduledMessages{}, entry_id, update_params)
      when is_integer(entry_id) do
    %{entries: entries} = scheduled_messages

    with entry when not is_nil(entry) <- entries[entry_id],
         {:ok, updated_entry} <- ScheduledMessage.update_entry(entry, update_params) do
      new_entries = Map.put(entries, entry_id, updated_entry)

      %ListScheduledMessages{scheduled_messages | entries: new_entries}
    else
      _ -> scheduled_messages
    end
  end

  def update_entry(_scheduled_messages, _entry_id, _updated_entry), do: raise(ArgumentError)
end
