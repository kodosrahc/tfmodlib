variable "tmpdir" {
  description = "path where config files are created"
  type = string
  default = "/tmp"
}

variable "content" {
  type = string
}
variable "name" {
  type = string
}

variable "base_url" {
  type = string
}

variable "config" {
  type = string
}
