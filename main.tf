terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "0.0.23"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_integer" "exampleAppSuffix" {
  min = 1000
  max = 9999
}

resource "fly_app" "exampleApp" {
  name = "dry-fire-${random_integer.exampleAppSuffix.result}"
  org  = "personal"
}

resource "fly_ip" "exampleIp" {
  app        = fly_app.exampleApp.name
  type       = "v4"
  depends_on = [fly_app.exampleApp]
}

resource "fly_ip" "exampleIpv6" {
  app        = fly_app.exampleApp.name
  type       = "v6"
  depends_on = [fly_app.exampleApp]
}

resource "fly_machine" "exampleMachine" {
  for_each = toset(["dfw", "ewr", "lax"])
  app      = fly_app.exampleApp.name
  region   = each.value
  name     = "pythoninthegrass-fly-iac-${each.value}"
  image    = "ghcr.io/pythoninthegrass/go-example:latest"
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]
        },
        {
          port     = 80
          handlers = ["http"]
        }
      ]
      "protocol" : "tcp",
      "internal_port" : 8080
    }
  ]
  cpus       = 1
  memorymb   = 256
  depends_on = [fly_app.exampleApp]
}
