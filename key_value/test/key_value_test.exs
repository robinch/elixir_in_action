defmodule KeyValueTest do
  use ExUnit.Case

  test "store and get" do
    {:ok, pid} = KeyValue.start_link()
    assert is_pid(pid)

    KeyValue.put("key", "stored_value")

    assert KeyValue.get("key") == "stored_value"
  end
end
