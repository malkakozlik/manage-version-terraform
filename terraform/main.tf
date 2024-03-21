terraform {
  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "myfirsttrail"
    container_name       = "manage-version-terraform"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}


data "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
}

data "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
}

resource "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan_name[count.index]
  resource_group_name = data.azurerm_storage_account.storage_account.resource_group_name
  location            = data.azurerm_storage_account.storage_account.location
  os_type             = "Linux"
  sku_name            = "P1v2"

  count = length(var.app_service_plan_name)
}

resource "azurerm_linux_function_app" "linux_function_app" {
  name                        = var.function_app_name[count.index]
  resource_group_name         = data.azurerm_storage_account.storage_account.resource_group_name
  location                    = data.azurerm_storage_account.storage_account.location
  storage_account_name        = data.azurerm_storage_account.storage_account.name
  storage_account_access_key  = data.azurerm_storage_account.storage_account.primary_access_key
  service_plan_id             = azurerm_service_plan.service_plan[count.index].id
  functions_extension_version = "~4"

  site_config {
    always_on = true
    application_stack {
      docker {
        registry_url = var.DOCKER_REGISTRY_SERVER_URL
        image_name = var.IMAGE_NAME
        image_tag = var.IMAGE_TAG
        registry_username = var.DOCKER_REGISTRY_SERVER_USERNAME
        registry_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
      }
    }
  } 

  identity {
    type = "SystemAssigned"
  }
  count= length(var.function_app_name)
}
