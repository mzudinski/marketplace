run.job Pluck {
  main = {
    name : "Pluck"
    input: {
      array: [{name: "barney", age: 36}, {name: "fred", age: 40}]
      key  : "name"
    }
  }
}
---
// Retrieves the value of a specified property from all elements in the collection.
function Pluck {
  input {
    json[] array?
    text key? filters=trim
  }

  stack {
    var $ouput {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        var.update $ouput {
          value = $ouput|push:($item|get:$input.key:null)
        }
      }
    }
  }

  response = $ouput
}