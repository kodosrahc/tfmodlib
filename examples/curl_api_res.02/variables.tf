locals {

  base_url = "https://localhost"

  api_res = {
    "some_res/res-A01" = {
      one = "eins",
      two = "zwei",
    }
    "another_res/res-B01" = {
      do = {
        subject = "user"
        action = "view"
      }
    }
  }

}
