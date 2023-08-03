resource "shoreline_notebook" "apache_restart_incident" {
  name       = "apache_restart_incident"
  data       = file("${path.module}/data/apache_restart_incident.json")
  depends_on = [shoreline_action.invoke_monitor_system_resources,shoreline_action.invoke_upgrade_apache,shoreline_action.invoke_restart_apache_server]
}

resource "shoreline_file" "monitor_system_resources" {
  name             = "monitor_system_resources"
  input_file       = "${path.module}/data/monitor_system_resources.sh"
  md5              = filemd5("${path.module}/data/monitor_system_resources.sh")
  description      = "Resource Constraints: If the server running Apache is running low on memory, CPU, or disk space, Apache may fail to respond, requiring a restart."
  destination_path = "/agent/scripts/monitor_system_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "upgrade_apache" {
  name             = "upgrade_apache"
  input_file       = "${path.module}/data/upgrade_apache.sh"
  md5              = filemd5("${path.module}/data/upgrade_apache.sh")
  description      = "Verify that all dependencies and libraries required by Apache are installed and up to date. Update any outdated packages if necessary."
  destination_path = "/agent/scripts/upgrade_apache.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_apache_server" {
  name             = "restart_apache_server"
  input_file       = "${path.module}/data/restart_apache_server.sh"
  md5              = filemd5("${path.module}/data/restart_apache_server.sh")
  description      = "Test the restart manually to ensure that the Apache server is running correctly."
  destination_path = "/agent/scripts/restart_apache_server.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_monitor_system_resources" {
  name        = "invoke_monitor_system_resources"
  description = "Resource Constraints: If the server running Apache is running low on memory, CPU, or disk space, Apache may fail to respond, requiring a restart."
  command     = "`chmod +x /agent/scripts/monitor_system_resources.sh && /agent/scripts/monitor_system_resources.sh`"
  params      = []
  file_deps   = ["monitor_system_resources"]
  enabled     = true
  depends_on  = [shoreline_file.monitor_system_resources]
}

resource "shoreline_action" "invoke_upgrade_apache" {
  name        = "invoke_upgrade_apache"
  description = "Verify that all dependencies and libraries required by Apache are installed and up to date. Update any outdated packages if necessary."
  command     = "`chmod +x /agent/scripts/upgrade_apache.sh && /agent/scripts/upgrade_apache.sh`"
  params      = []
  file_deps   = ["upgrade_apache"]
  enabled     = true
  depends_on  = [shoreline_file.upgrade_apache]
}

resource "shoreline_action" "invoke_restart_apache_server" {
  name        = "invoke_restart_apache_server"
  description = "Test the restart manually to ensure that the Apache server is running correctly."
  command     = "`chmod +x /agent/scripts/restart_apache_server.sh && /agent/scripts/restart_apache_server.sh`"
  params      = ["APACHE_URL"]
  file_deps   = ["restart_apache_server"]
  enabled     = true
  depends_on  = [shoreline_file.restart_apache_server]
}

