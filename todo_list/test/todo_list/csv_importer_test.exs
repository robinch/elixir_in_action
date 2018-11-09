defmodule TodoList.CsvImporterTest do
  use ExUnit.Case

  @test_file "test/assets/test.csv"

  test 'import file' do
    assert TodoList.CsvImporter.import(@test_file) ==
             TodoList.new([
               %{date: ~D[2018-12-19], title: "Dentist"},
               %{date: ~D[2018-12-20], title: "Shopping"},
               %{date: ~D[2018-12-19], title: "Movies"}
             ])
  end
end
