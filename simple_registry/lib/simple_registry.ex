defmodule SimpleRegistry do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whois, name})
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_call({:register, name}, {caller_pid, _}, registry) do
    {reply, new_registry} =
      if Map.get(registry, name) do
        {:error, registry}
      else
        Process.link(caller_pid)
        {:ok, Map.put(registry, name, caller_pid)}
      end

    {:reply, reply, new_registry}
  end

  def handle_call({:whois, name}, _, registry) do
    {:reply, Map.get(registry, name), registry}
  end

  def handle_info({:EXIT, terminated_pid, _reason}, registry) do
    new_registry =
      Enum.filter(registry, fn {_name, pid} -> pid != terminated_pid end)
      |> Map.new()

    {:noreply, new_registry}
  end
end
