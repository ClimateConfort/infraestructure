variable "gcp_credentials_file" {
	description = "Sets the path of the credentials file"
	type = string
}

variable "gcp_project" {
	description = "Set project name"
	type = string
}

variable "gcp_region" {
	description = "Set region"
	type = string
}

variable "gcp_zone" {
	description = "Set zone"
	type = string
}

variable "gcp_account_email" {
	description = "Set account email"
	type = string
}

variable "gcp_account_scopes" {
	description = "Array of account scopes"
	type = list
}
