module "do_curl_one" {
  source = "../..//modules/curl_api_res"

  for_each = toset(keys(local.api_res))
  resource = each.key
  content  = jsonencode(local.api_res[each.key])
  base_url = local.base_url
  # make config "sensitive" if pass data like credentials
  config = sensitive(<<-EOT
    user = iam:pass
    header = "Content-Type: application/json"
  EOT
  )
}
