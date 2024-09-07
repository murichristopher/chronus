defmodule CalculatorGenServer do
  use GenServer

  def init(value) do
    {:ok, value}
  end

  def start(initial_value) do
    GenServer.start(__MODULE__, initial_value)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def double(pid) do
    GenServer.cast(pid, :double)
  end

  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  def handle_cast(:double, state) do
    {:noreply, state * 2}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end

# {:ok, pid} = CalculatorGenServer.start(2)

# CalculatorGenServer.double(pid)
# CalculatorGenServer.double(pid)
# CalculatorGenServer.double(pid)
# CalculatorGenServer.get(pid)
# |> IO.inspect()
