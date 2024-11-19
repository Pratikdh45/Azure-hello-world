terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9.0"  # or the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6b95c15d-159f-49ec-9b91-a83208e2b4a3"  # add azure subscription ID
}


# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.location
  name = var.appservicename
}

# App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = "Akshay-hello-world"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "F1"      
  os_type             = "Linux" # or "Linux" depending on your app
}


# App Service (Web App)
resource "azurerm_windows_web_app" "web_app" {
  name                = "Pratik-hello-world-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id  

  site_config {
    always_on = false # Explicitly set always_on to false for Free/F1/D1 SKU
    application_stack {
      current_stack = "dotnetcore"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
