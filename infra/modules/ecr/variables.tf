variable "repo_name" {
  type = string
}

variable "image_tag_mutability" {
  description = "MUTABLE allows a moving tag"
  type        = string
  default     = "MUTABLE"
}

variable "keep_tagged" {
  description = "How many sha- tagged images to keep; older ones expire. Rollback can only reach images still kept."
  type        = number
  default     = 30
}
