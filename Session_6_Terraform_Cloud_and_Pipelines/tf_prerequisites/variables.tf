variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default = "jijun6"
}

variable "repo_name" {
  description = "GitHub repository name including the owner (e.g., OWNER/REPOSITORY)"
  type        = string
  default     = "tw-wuqian/infra-as-code-lab-exercise.git"
}