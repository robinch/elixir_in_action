defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  @number_of_workers 3

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, initialize_workers()}
  end

  def handle_call({:choose_worker, key}, _, workers) do
    worker_nr = :erlang.phash2(key, 3)

    {:reply, Map.get(workers, worker_nr), workers}
  end

  defp initialize_workers() do
    Enum.reduce(0..(@number_of_workers - 1), %{}, fn worker, map ->
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      Map.put(map, worker, pid)
    end)
  end
end
