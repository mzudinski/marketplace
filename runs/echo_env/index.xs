run.job "Echo Env" {
  main = {name: "echo", input: {}}
  env = ["test"]
}
---
function echo {
  input {}
  stack {}
  response = $env.test
}
