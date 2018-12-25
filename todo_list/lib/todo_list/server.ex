defmodule TodoList.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, TodoList.new()}
  end

  def add_entry(new_entry) do
    GenServer.cast(__MODULE__, {:add, new_entry})
  end

  def delete_entry(entry_id) do
    GenServer.cast(__MODULE__, {:delete, entry_id})
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  def handle_cast({:add, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _from, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end
end
