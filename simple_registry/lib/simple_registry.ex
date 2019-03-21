defmodule SimpleRegistry do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    if :ets.insert_new(__MODULE__, {name, self()}) do
      Process.link(whereis(__MODULE__))
      :ok
    else
      :error
    end
  end

  def whereis(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, value}] -> value
      [] -> nil
    end
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:public, :named_table])
    :ets.insert_new(__MODULE__, {__MODULE__, self()})
    {:ok, %{}}
  end

  def handle_info({:EXIT, terminated_pid, _reason}, state) do
    :ets.match_object(__MODULE__, {:_, terminated_pid})
    |> IO.inspect()
    |> Enum.each(fn {name, _pid} -> :ets.delete(__MODULE__, name) end)

    {:noreply, state}
  end
end
