# Create an organisation scope within global, named "boundary-demo-org"
# The global scope can contain multiple org scopes
resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "boundary-demo-org"
  description              = "Terraform created org for Boundary Demo"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

/* Create a project scope within the "boundary-demo-org" organsiation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = "boundary-demo-project"
  description              = "Terraform created project for Boundary Demo"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}