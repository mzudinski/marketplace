// The array paginator is a function that divides a large array into smaller chunks, allowing you to display only a specific portion (or “page”) of the array at a time. It takes in parameters like the number of items you want per page (per_page) and the current page (page), and returns a portion of the array corresponding to that page. 
// 
// This is useful if you are working with Redis lists, need to break apart a large dataset into smaller chunks for loops and more.
// 
// In addition to the paginated items, it also calculates useful metadata, such as:
// 
// 	•	The total number of items in the array.
// 	•	The total number of pages.
// 	•	The current page.
// 	•	The next page (if there is one).
// 	•	The previous page (if there is one).
// 
// This allows for easier navigation through large datasets by breaking them up into smaller, manageable “pages.”
function "Paginate array" {
  input {
    // The array you wish to paginate.
    json array
  
    int page?=1 filters=min:1
    int per_page?=10 filters=min:1
  }

  stack {
    // Validate incoming array
    group {
      stack {
        var $is_array {
          value = $input.array|is_array
        }
      
        precondition ($is_array) {
          error_type = "inputerror"
          error = $is_array
          payload = "The provided data is not a numerically indexed array"
        }
      }
    }
  
    // Prepare variables for slicing array
    group {
      stack {
        var $page {
          value = $input.page
        }
      
        var $array_count {
          value = $input.array|count
        }
      
        var $total_pages {
          value = ($var.array_count / $input.per_page)|ceil
        }
      
        var $next_page {
          value = ($var.page < $var.total_pages) ? $var.page + 1 : null
        }
      
        var $previous_page {
          value = ($var.page > 1 && $var.page <= $var.total_pages) ? $var.page - 1 : null
        }
      
        // Handle edge case when page is greater than total pages
        conditional {
          if ($input.page > $total_pages) {
            var.update $page {
              value = $total_pages
            }
          
            var $offset {
              value = ($var.page -1) * $input.per_page
            }
          }
        
          else {
            var $offset {
              value = ($var.page -1) * $input.per_page
            }
          }
        }
      }
    }
  
    // Slicing the Array
    var $paginated_array {
      value = $input.array|slice:$offset:$input.per_page
    }
  
    // Generate response
    var $response {
      value = {}
        |set:"itemsReceived":$array_count
        |set:"curPage":$page
        |set:"nextPage":$next_page
        |set:"prevPage":$previous_page
        |set:"offset":$offset
        |set:"pageTotal":$total_pages
        |set:"items":$paginated_array
    }
  }

  response = $response
}