defmodule SimpleRegistryTest do
  use ExUnit.Case

  test "create registry" do
    # {:ok, pid} = SimpleRegistry.start_link()
    # assert is_pid(pid)
  end

  test "register process" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register(:test) |> IO.inspect() == :ok
  end

  test "register with already existing name" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register(:test) == :ok
    assert SimpleRegistry.register(:test) == :error
  end

  test "whereis on existing name" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register(:test) == :ok
    assert SimpleRegistry.whereis(:test) == self()
  end

  test "whereis on non-existing name" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.whereis(:test) == nil
  end

  test "remove terminated processess" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register(:long_process) == :ok

    spawn(fn ->
      assert SimpleRegistry.register(:short_process) == :ok
      assert SimpleRegistry.whereis(:short_process) == self()
    end)

    Process.sleep(500)
    assert SimpleRegistry.whereis(:short_process) == nil
    assert SimpleRegistry.whereis(:long_process) != nil
  end
end
