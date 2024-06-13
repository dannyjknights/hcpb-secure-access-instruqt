# resource "boundary_storage_bucket" "boundary_storage_bucket" {
#   name            = "boundary-s3-bucket"
#   scope_id        = "global"
#   plugin_name     = "aws"
#   bucket_name     = aws_s3_bucket.boundary_session_recording_bucket.bucket
#   attributes_json = jsonencode({ "region" = "eu-west-2", "disable_credential_rotation" = true })

#   secrets_json = jsonencode({
#     "access_key_id"     = var.aws_access,
#     "secret_access_key" = var.aws_secret
#   })
#   worker_filter = " \"self-managed-aws-worker\" in \"/tags/type\" "
# }