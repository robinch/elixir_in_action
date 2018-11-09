defmodule TodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&entry_from_row/1)
    |> TodoList.new()
  end

  defp entry_from_row(row) do
    [date_string, title] = String.split(row, ",")

    [year, month, day] =
      String.split(date_string, "/")
      |> Enum.map(&String.to_integer/1)

    {:ok, date} = Date.new(year, month, day)

    %{date: date, title: title}
  end
end
