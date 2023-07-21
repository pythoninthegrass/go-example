output "instance_name" {
  value = fly_app.exampleApp.name
}

output "instance_image" {
  # value = fly_machine.exampleMachine.image
  value = {
    for machine in fly_machine.exampleMachine : machine.name => try(machine.image, null)
  }
}

output "instance_availability" {
  # value = fly_machine.exampleMachine.region
  value = {
    for machine in fly_machine.exampleMachine : machine.name => try(machine.region, null)
  }
}

# ! NOTE: only "privateip" is available when using "for_each"
# output "instance_ip_v4" {
#   # value = fly_ip.exampleIp.address
# }

output "instance_cpu" {
  # value = fly_machine.exampleMachine.cpus
  value = {
    for machine in fly_machine.exampleMachine : machine.name => try(machine.cpus, null)
  }
}

# * NOTE: "must be in 256 MiB increment"
output "instance_ram" {
  # value = fly_machine.exampleMachine.memorymb
  value = {
    for machine in fly_machine.exampleMachine : machine.name => try(machine.memorymb, null)
  }
}

output "instance_env" {
  # value = fly_machine.exampleMachine.env
  value = {
    for machine in fly_machine.exampleMachine : machine.name => try(machine.env, null)
  }
}
