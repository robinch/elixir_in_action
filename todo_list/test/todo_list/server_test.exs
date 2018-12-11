defmodule TodoList.ServerTest do
  use ExUnit.Case

  test "delete a entry" do
    TodoList.Server.start()
    TodoList.Server.add_entry(%{date: ~D[2018-11-15], title: "Dentist"})

    entry = hd(TodoList.Server.entries(~D[2018-11-15]))
    assert entry.title == "Dentist"
    assert entry.date == ~D[2018-11-15]

    TodoList.Server.delete_entry(entry.id)

    assert TodoList.Server.entries(~D[2018-11-15]) == []
  end
end
