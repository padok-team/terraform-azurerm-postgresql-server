## To enable for google module
## ruleset: https://github.com/terraform-linters/tflint-ruleset-google/blob/master/docs/rules/README.md
# plugin "google" {
#     enabled = true
#     version = "0.15.0"
#     source  = "github.com/terraform-linters/tflint-ruleset-google"
# }

## To enable for azure module
## ruleset: https://github.com/terraform-linters/tflint-ruleset-azurerm/blob/master/docs/README.md
# plugin "azurerm" {
#     enabled = true
#     version = "0.14.0"
#     source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
# }

## To enable for aws module
## ruleset: https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/rules/README.md
# plugin "aws" {
#     enabled = true
#     version = "0.11.0"
#     source  = "github.com/terraform-linters/tflint-ruleset-aws"
#
#     deep_check = true
# }

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}
