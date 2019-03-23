defmodule Todo.CacheTest do
  use ExUnit.Case, async: false

  @dbs %{
    bob: "DB_#{__MODULE__}_bob",
    alice: "DB_#{__MODULE__}_alice"
  }

  setup_all do
    on_exit(fn ->
      Enum.each(@dbs, fn {_key, db_name} ->
        File.rm_rf!("persist/#{db_name}")
      end)
    end)

    :ok
  end

  test "server process" do
    bob_pid = Todo.Cache.server_process(@dbs.bob)

    assert bob_pid != Todo.Cache.server_process(@dbs.alice)
    assert bob_pid == Todo.Cache.server_process(@dbs.bob)
  end

  test "to-do operations" do
    alice = Todo.Cache.server_process(@dbs.alice)
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})

    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert length(entries) == 1

    entry = entries |> hd()

    assert entry.date == ~D[2018-12-19]
    assert entry.title == "Dentist"

    Todo.Server.delete_entry(alice, entry.id)
    assert Todo.Server.entries(alice, ~D[2018-12-19]) == []
  end
end
