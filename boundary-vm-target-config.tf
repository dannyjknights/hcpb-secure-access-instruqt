# Boundary config for the EC2 target
resource "boundary_host_catalog_plugin" "aws_plugin" {
  name        = "AWS Catalogue"
  description = "AWS Dynamic Host Catalogue"
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

resource "boundary_host_set_plugin" "aws_dev" {
  name                  = "AWS Host Set Plugin - Dev"
  description           = "AWS Host Set looking for EC2 resources with the tag 'dev'"
  host_catalog_id       = boundary_host_catalog_plugin.aws_plugin.id
  preferred_endpoints   = ["cidr:0.0.0.0/0"]
  attributes_json       = jsonencode({ "filters" = "tag:application=dev" })
  sync_interval_seconds = 30
}

resource "boundary_target" "aws" {
  type                     = "ssh"
  name                     = "aws-ec2"
  description              = "AWS EC2 Target"
  egress_worker_filter     = " \"self-managed-aws-worker\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_plugin.aws_dev.id,
  ]
  # enable_session_recording                   = true
  # storage_bucket_id                          = aws_s3_bucket.boundary_session_recording_bucket.id
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