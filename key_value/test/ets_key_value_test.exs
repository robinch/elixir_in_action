defmodule EtsKeyValueTest do
  use ExUnit.Case

  test "store and get a value" do
    EtsKeyValue.start_link()

    EtsKeyValue.put("key", "stored_value")

    assert EtsKeyValue.get("key") == "stored_value"
  end

  test "get a non-stored key" do
    EtsKeyValue.start_link()

    assert EtsKeyValue.get("non-stored key") == nil
  end
end
