resource "null_resource" "curl" {
  triggers = {
    resource    = var.resource
    content     = var.content
    base_url    = var.base_url
    config      = var.config  # config change also triggers recreate
  }

  provisioner "local-exec" {
    environment = {
      # CURLRC = base64encode(var.config) # this way of referring to config works, but not for destroy provisioner
      CURLRC = base64encode(self.triggers.config)
    }
    command = <<-EOT
      echo $CURLRC| base64 -d| curl -s -K- -XPUT ${self.triggers.base_url}/${self.triggers.resource} --data-raw '${self.triggers.content}'
    EOT
  }
  provisioner "local-exec" {
    when = destroy
    environment = {
      CURLRC = base64encode(self.triggers.config)
    }
    command = <<-EOT
      echo $CURLRC| base64 -d| curl -s -K- -XDELETE ${self.triggers.base_url}/${self.triggers.resource}
    EOT
  }
}
