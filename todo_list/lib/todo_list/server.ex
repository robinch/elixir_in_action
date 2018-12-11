defmodule TodoList.Server do
  def start() do
    ServerProcess.start(__MODULE__)
    |> Process.register(:todo_server)
  end

  def init() do
    TodoList.new()
  end

  def add_entry(new_entry) do
    ServerProcess.cast(:todo_server, {:add, new_entry})
  end

  def delete_entry(entry_id) do
    ServerProcess.cast(:todo_server, {:delete, entry_id})
  end

  def entries(date) do
    ServerProcess.call(:todo_server, {:entries, date})
  end

  def handle_cast({:add, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end
end
