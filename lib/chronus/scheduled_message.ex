
defmodule Chronus.ScheduledMessage do
  alias Chronus.ScheduledMessage

  @enforce_keys [:body, :send_at, :from, :to]

  defstruct body: nil, send_at: nil, from: nil, to: nil

  def new(attrs) when is_map(attrs) do
    with true <- Enum.all?(@enforce_keys, &Map.has_key?(attrs, &1)) do
      validate(struct!(__MODULE__, attrs))
    else
      _ -> raise ArgumentError, "The required keys #{inspect(@enforce_keys)} are not all present."
    end
  end

  def update_entry(entry = ScheduledMessage, _update_params) do
    {:ok, entry}
  end

  defp validate(%__MODULE__{} = scheduled_message), do: scheduled_message
end

defimpl Jason.Encoder, for: Chronus.ScheduledMessage do
  def encode(%Chronus.ScheduledMessage{body: body, send_at: send_at, from: from, to: to}, opts) do
    Jason.Encode.map(%{body: body, send_at: send_at, from: from, to: to}, opts)
  end
end
