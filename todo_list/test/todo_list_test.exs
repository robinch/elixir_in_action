defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test 'new todo list' do
    assert TodoList.new() == %TodoList{}
  end

  test 'new todo list with entries' do
    entries = [
      %{date: ~D[2018-11-08], title: "Dentist"},
      %{date: ~D[2018-11-09], title: "Shopping"}
    ]

    todo_list = TodoList.new(entries)

    entry1 = hd(TodoList.entries(todo_list, ~D[2018-11-08]))
    assert entry1.date == ~D[2018-11-08]
    assert entry1.title == "Dentist"

    entry2 = hd(TodoList.entries(todo_list, ~D[2018-11-09]))
    assert entry2.date == ~D[2018-11-09]
    assert entry2.title == "Shopping"
  end

  test 'add new entry' do
    todo =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "new entry"})
      |> TodoList.entries(~D[2018-11-05])
      |> Enum.map(&Map.take(&1, [:date, :title]))

    assert todo == [%{date: ~D[2018-11-05], title: "new entry"}]
  end

  test 'add several entries with two i the same day' do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "entry same day"})
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "another entry same day"})
      |> TodoList.add_entry(%{date: ~D[2018-11-08], title: "entry different day"})

    two_entries =
      todo_list
      |> TodoList.entries(~D[2018-11-05])
      |> Enum.map(&Map.take(&1, [:date, :title]))

    assert two_entries == [
             %{date: ~D[2018-11-05], title: "entry same day"},
             %{date: ~D[2018-11-05], title: "another entry same day"}
           ]

    one_entries =
      todo_list
      |> TodoList.entries(~D[2018-11-08])
      |> Enum.map(&Map.take(&1, [:date, :title]))

    assert one_entries == [%{date: ~D[2018-11-08], title: "entry different day"}]
  end

  test 'update existing entry' do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "new entry"})

    old_entry = hd(TodoList.entries(todo_list, ~D[2018-11-05]))

    assert old_entry.date == ~D[2018-11-05]
    assert old_entry.title == "new entry"

    todo_list =
      TodoList.update_entry(
        todo_list,
        old_entry.id,
        &%{&1 | date: ~D[2018-11-08], title: "updated entry"}
      )

    new_entry = hd(TodoList.entries(todo_list, ~D[2018-11-08]))

    assert new_entry.date == ~D[2018-11-08]
    assert new_entry.title == "updated entry"
  end

  test 'update non-existing entry' do
    old_todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "new entry"})

    old_entry = hd(TodoList.entries(old_todo_list, ~D[2018-11-05]))

    updated_todo_list =
      TodoList.update_entry(
        old_todo_list,
        old_entry.id + 1,
        &%{&1 | date: ~D[2018-11-08], title: "updated entry"}
      )

    assert old_todo_list == updated_todo_list
  end

  test 'delete entry' do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-11-05], title: "entry"})

    entry = hd(TodoList.entries(todo_list, ~D[2018-11-05]))

    assert entry.date == ~D[2018-11-05]
    assert entry.title == "entry"

    todo_list = TodoList.delete_entry(todo_list, entry.id)

    assert TodoList.entries(todo_list, ~D[2018-11-05]) == []
  end
end
