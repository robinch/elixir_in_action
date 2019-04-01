system = :todo_system@localhost

if Node.connect(system) == true do
  :rpc.call(system, System, :stop, [])
  IO.puts("Node terminated")
else
  IO.puts("Can't connct to node")
end
