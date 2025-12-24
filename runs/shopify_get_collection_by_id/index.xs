run "Shopify -> Get Collection by ID" {
  type = "job"
  main = {name: "Shopify -> Get Collection by ID", input: {}}
  env = ["access_token", "store"]
}
---
function "Shopify -> Get Collection by ID" {
  input {
    text collection_id filters=trim
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:$env.store
          method = "POST"
          params = {}
            |set:"query":"query CollectionMetafield($namespace: String!, $key: String!, $ownerId: ID!) { collection(id: $ownerId) { id title handle description image { url altText } products(first: 10) { edges { node { id title handle status totalInventory } } } subtitle: metafield(namespace: $namespace, key: $key) { value } } }"
            |set:"variables":({}
              |set:"namespace":"my_fields"
              |set:"key":"subtitle"
              |set:"ownerId":("gid://shopify/Collection/%s"|sprintf:$input.collection_id)
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Shopify-Access-Token: %s"|sprintf:$env.access_token)
        } as $shopify_api
      }
    }
  
    precondition ($shopify_api.response.status == 200) {
      error = "Uh oh, the Shopify API responded with a %s"
        |sprintf:$shopify_api.response.status
    }
  }

  response = $shopify_api.response.result
}