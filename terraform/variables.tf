variable DOCKER_REGISTRY_SERVER_PASSWORD {
  type = string
}

variable DOCKER_REGISTRY_SERVER_USERNAME {
  type = string
}

variable DOCKER_REGISTRY_SERVER_URL {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "rg_name" {
  default = "NetworkWatcherRG"
}

variable "storage_account_name" {
  default = "myfirsttrail"
}

variable "app_service_plan_name"{
    type = list(string)
    default = ["app-version-user-disable-automation"]
}

variable "function_app_name"{
    type = list(string)
    default = ["version-user-disable-automation"]
}

variable IMAGE_NAME {
  type    = string
  default = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type    = string
  default = "4-appservice-quickstart"
}
