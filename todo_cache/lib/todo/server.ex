defmodule Todo.Server do
  use GenServer, restart: :temporary

  @expiry_idle_timer :timer.seconds(10)

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add, new_entry})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete, entry_id})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def init(name) do
    IO.puts("Starting to-do server for #{name}")
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}, @expiry_idle_timer}
  end

  def handle_cast({:add, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timer}
  end

  def handle_cast({:delete, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timer}
  end

  def handle_call({:entries, date}, _from, state = {_, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), state, @expiry_idle_timer}
  end

  def handle_info(:timeout, {name, todo_list}) do
    IO.puts("Stopping to-do server for #{name}")
    {:stop, :normal, {name, todo_list}}
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
