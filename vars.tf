variable "project_id" {
  default     = "995a705bb1254b868c2aaa4e8912287b"
  nullable    = false
  type        = string
  description = "Project ID"
}

variable "auth_url" {
  default     = "https://overcloud.do.intra:13000"
  nullable    = false
  type        = string
  description = "Auth URL"
}

variable "username" {
  default     = "ypomie"
  nullable    = false
  type        = string
  description = "Username"
}

variable "password" {
  nullable    = false
  type        = string
  description = "Password"
  sensitive   = true
}

variable "region_name" {
  default     = "regionOne"
  nullable    = false
  type        = string
  description = "Region Name"
}

variable "key_name" {
  nullable    = false
  type        = string
  description = "Key Name"
}

variable "nb_masters" {
  nullable    = false
  type        = number
  default     = 1
  description = "Number of master nodes"
  validation {
    condition     = var.nb_masters > 0
    error_message = "Number of master nodes must be greater than 0"
  }
}

variable "nb_instances" {
  nullable    = false
  type        = number
  default     = 2
  description = "Number of nodes"
  validation {
    condition     = var.nb_instances > 0
    error_message = "Total of nodes must be greater than 0"
  }
}

variable "ssh_key_path" {
  nullable    = false
  type        = string
  description = "SSH key path"
  default     = "~/.ssh/id_ed25519"
}