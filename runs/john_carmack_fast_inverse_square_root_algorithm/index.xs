workspace john_carmack_fast_inverse_square_root_algorithm
---
// John Carmack’s fast inverse square root function is a famous algorithm used in computer graphics, particularly in 3D rendering, to compute the inverse square root of a number quickly. 
// 
// It was notably used in the Quake III Arena game engine to speed up computations related to lighting, shading, and physics. The function approximates the value of 1/sqrt(x) very efficiently, significantly faster than the traditional method of calculating a square root followed by division.
function "$main" {
  input {
    int number?
  }

  stack {
    var $y {
      value = $input.number
    }
  
    var $three_halfs {
      value = 1.5
    }
  
    var $x2 {
      value = $input.number * 0.5
    }
  
    var $what_the_magic_number_is_for {
      value = 1597463007
    }
  
    var $approximation {
      value = 1 / $input.number|sqrt
    }
  
    var $i {
      value = $var.y * ($var.three_halfs - ($var.x2 * $var.y * $var.y))
    }
  
    var $y {
      value = $i|to_decimal
    }
  
    var $the_goat {
      value = $approximation
    }
  }

  response = $the_goat
}