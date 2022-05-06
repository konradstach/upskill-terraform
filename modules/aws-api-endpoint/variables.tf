variable "api_id" {
  type = string
}

variable "route_key" {
  type = string
}

variable "route_authorization_type" {
  type = string
}
variable "route_authorizer_id" {
  type = string
}
variable "integration_type" {
  type = string
  default = "AWS_PROXY"
}
variable "integration_uri" {
  type = string
}
variable "integration_method" {
  type = string
  default = "POST"
}


