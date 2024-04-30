# Create an organisation scope within global, named "partner-demo-org"
# The global scope can contain multiple org scopes
resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "partner-demo-org"
  description              = "Terraform created org for Partner Demo"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

/* Create a project scope within the "partner-demo-org" organsiation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = "partner-demo-project"
  description              = "Terraform created project for Partner Demo"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}