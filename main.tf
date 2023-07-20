terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "0.0.20"
    }
  }
}

provider "fly" {
  useinternaltunnel    = true
  internaltunnelorg    = "personal"
  internaltunnelregion = "dfw"
}

resource "fly_app" "exampleApp" {
  name = "dry-fire-7752"
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
  name     = "flyiac-${each.value}"
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
      "internal_port" : 80
    },
  ]
  cpus       = 1
  memorymb   = 256
  depends_on = [fly_app.exampleApp]
}
