defmodule KeyValueStoreTest do
  use ExUnit.Case

  test "put and get value" do
    KeyValueStore.start()

    KeyValueStore.put(:test, "this is a test")
    assert KeyValueStore.get(:test) == "this is a test"
  end
end
