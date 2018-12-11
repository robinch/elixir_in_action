defmodule TodoList.OldServer do
  def start() do
    spawn(fn -> loop(TodoList.new()) end)
    |> Process.register(:todo_server)
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add, new_entry})
  end

  def delete_entry(entry_id) do
    send(:todo_server, {:delete, entry_id})
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:delete, entry_id}) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end
end
