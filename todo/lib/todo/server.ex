defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Todo.List.new()}
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

  def handle_cast({:add, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _from, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end
end
