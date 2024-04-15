#Boundary config for the Postgres DB target
resource "boundary_host_catalog_static" "db_host_catalog" {
  scope_id = boundary_scope.project.id
}

resource "boundary_host_static" "postgres_host" {
  type            = "static"
  name            = "Postgres Host"
  address         = aws_db_instance.boundary_demo.address
  host_catalog_id = boundary_host_catalog_static.db_host_catalog.id
}

resource "boundary_host_set_static" "db_static_host_set" {
  name            = "Postgres Static Host Set"
  host_catalog_id = boundary_host_catalog_static.db_host_catalog.id

  host_ids = [boundary_host_static.postgres_host.id]
}

resource "boundary_target" "dba" {
  type                     = "tcp"
  name                     = "RDS DBA Access"
  description              = "RDS DBA Permissions"
  egress_worker_filter     = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = 3600
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.db_static_host_set.id
  ]

  brokered_credential_source_ids = [
    boundary_credential_library_vault.vault_cred_lib.id
  ]
}


# Boundary config for the EC2 target
resource "boundary_host_catalog_plugin" "aws_plugin" {
  name        = "AWS Catalogue"
  description = "AWS Host Catalogue"
  scope_id    = boundary_scope.project.id
  plugin_name = "aws"
  attributes_json = jsonencode({
    "region" = "eu-west-2",
  "disable_credential_rotation" = true })


  secrets_json = jsonencode({
    "access_key_id"     = var.aws_access,
    "secret_access_key" = var.aws_secret
  })
}

resource "boundary_host_set_plugin" "aws-db" {
  name                  = "AWS DB Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:service-type=database" })
  sync_interval_seconds = 30
}

resource "boundary_host_set_plugin" "aws-dev" {
  name                  = "AWS Dev Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:application=dev" })
  sync_interval_seconds = 30
}

resource "boundary_host_set_plugin" "aws-prod" {
  name                  = "AWS Prod Host Set Plugin"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:application=production" })
  sync_interval_seconds = 30
}

resource "boundary_target" "aws" {
  type                     = "ssh"
  name                     = "aws-ec2"
  description              = "AWS EC2 Targets"
  egress_worker_filter     = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  default_client_port      = 50505
  host_source_ids = [
    boundary_host_set_plugin.aws-db.id,
    boundary_host_set_plugin.aws-dev.id,
    boundary_host_set_plugin.aws-prod.id,
  ]
  enable_session_recording                   = true
  storage_bucket_id                          = boundary_storage_bucket.boundary_storage_bucket.id
  injected_application_credential_source_ids = [boundary_credential_library_vault_ssh_certificate.vault_ssh_cert.id]
}

resource "boundary_policy_storage" "strict_storage_policy" {
  scope_id          = boundary_scope.org.id
  delete_after_days = 1
  retain_for_days   = 0
  name              = "strictdeletepolicy"
  description       = "Policy to allow deletion at any time"
}

resource "boundary_scope_policy_attachment" "policy_attachment" {
  policy_id = boundary_policy_storage.strict_storage_policy.id
  scope_id  = boundary_scope.org.id

}