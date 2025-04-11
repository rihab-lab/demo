resource "snowflake_grant_account_role" "grant_poc_viseo_role_rbahri" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role.name
  user_name = snowflake_user.rihab_bahri.name
}
