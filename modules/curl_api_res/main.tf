resource "random_id" "filename" {
  prefix      = "tf."
  byte_length = 32
}

resource "local_file" "config" {
  filename = "${var.tmpdir}/${random_id.filename.b64_url}"
  content  = var.config
}

resource "null_resource" "curl" {
  triggers = {
    name        = var.name
    content     = var.content
    base_url    = var.base_url
    config_file = local_file.config.filename
    config_hash = sha256(local_file.config.content) # implicit dependency on local_file
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -s -K ${self.triggers.config_file} -XPUT ${self.triggers.base_url}/${self.triggers.name} --data-raw "${self.triggers.content}"
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      curl -s -K ${self.triggers.config_file} -XDELETE ${self.triggers.base_url}/${self.triggers.name}
    EOT
  }
}
