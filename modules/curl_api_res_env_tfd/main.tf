resource "terraform_data" "curl" {
  input = {
    # A change in the base_url doesn't trigger the resource replacement.
    # For instance the the new domain dame of the resource should not cause the replacement
    base_url = var.base_url
    config   = var.config
  }
  triggers_replace = {
    resource = var.resource
    content  = var.content
  }

  provisioner "local-exec" {
    environment = {
      # CURLRC = base64encode(var.config) # this way of referring to config works, but not for destroy provisioner
      CURLRC = base64encode(self.input.config)
    }
    command = <<-EOT
      echo $CURLRC| base64 -d| curl -s -K- -XPUT ${self.input.base_url}/${self.triggers_replace.resource} --data-raw '${self.triggers_replace.content}'
    EOT
  }
  provisioner "local-exec" {
    when = destroy
    environment = {
      CURLRC = base64encode(self.input.config)
    }
    command = <<-EOT
      echo $CURLRC| base64 -d| curl -s -K- -XDELETE ${self.input.base_url}/${self.triggers_replace.resource}
    EOT
  }
}
