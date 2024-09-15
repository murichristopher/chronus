## Message

```elixir
%{
  body: "Bom dia!!! Que seu dia seja repleto de alegrias e felicidades.",
  send_at: "2024-09-16 10:10:10" # UTC,
  from: "user_8345943559494395495",
  to: "chat_234982347348734748748"
}
```

```elixir
list = Chronus.ListScheduledMessages.new()

entry1 = Chronus.ScheduledMessage.new(%{
  body: "Olá! [TESTE A]",
  send_at: "2024-09-15 20:01:22",
  from: "user_8345943559494395495",
  to: "chat_234982347348734748748"
})

entry2 = Chronus.ScheduledMessage.new(%{
  body: "Oi! [TESTE B]",
  send_at: "2024-09-15 20:01:22",
  from: "user_8345943559494395495",
  to: "chat_234982347348734748748"
})

list = 
  list 
  |> Chronus.ListScheduledMessages.add_entry(entry1) 
  |> Chronus.ListScheduledMessages.add_entry(entry2)

Chronus.MessageServer.start()
Chronus.Scheduler.start()

{:ok, pid} = Chronus.ServerProcess.start
Chronus.ServerProcess.put(pid, entry1)
Chronus.ServerProcess.put(pid, entry2)
Chronus.ServerProcess.get(pid)
```

```elixir
pid = self

Process.send_after(pid, "OII", 3000)

receive do
  message -> IO.puts("Message Received: #{message}")
after 
  5_000 -> IO.puts("No message received.")
end

Process.info(self(), :messages)
```


```elixir
Chronus.MessageServer.start()
Chronus.Scheduler.start()

{:ok, pid} = Chronus.ServerProcess.start

entry1 = Chronus.ScheduledMessage.new(%{
  body: "03:20!!!",
  send_at: "2024-09-15T06:20:00Z",
  from: "user_8345943559494395495",
  to: "chat_234982347348734748748"
})

Chronus.ServerProcess.put(pid, entry1)
```