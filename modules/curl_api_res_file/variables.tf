variable "tmpdir" {
  description = "path where config files are created"
  type        = string
  default     = "/tmp"
}

variable "config_file_prefix" {
  description = "prefix of the generated config file names"
  type        = string
  default     = "tf."
}

variable "content" {
  type = string
}
variable "resource" {
  type = string
}

variable "base_url" {
  type = string
}

variable "config" {
  type = string
}
