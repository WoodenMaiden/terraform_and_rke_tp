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