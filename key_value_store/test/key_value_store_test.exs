defmodule KeyValueStoreTest do
  use ExUnit.Case

  test "put and get value" do
    pid = KeyValueStore.start()

    KeyValueStore.put(pid, :test, "this is a test")
    assert KeyValueStore.get(pid, :test) == "this is a test"
  end
end
