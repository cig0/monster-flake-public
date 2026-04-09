# Home Manager Zsh aliases module. Do not remove this header.
{
  ...
}:
let
  # Infrastructure-as-Code
  aliases = {
    # Terraform / Opentofu
    tf_debug = "export TF_LOG=DEBUG";
    tf = "tofu";
    tfi = "tofu init -reconfigure -backend-config=backend.hcl";
    tfp = "tofu plan";
    tfa = "tofu apply";
    tfd = "tofu destroy";
    tfv = "tofu validate";
    tff = "tofu fmt -recursive";
    tfo = "tofu output";
    tfs = "tofu show";
    tffu = "tofu force-unlock";
    tfslist = "tofu state list";
    tfsshow = "tofu state show";
    tfspull = "tofu state pull > terraform.tfstate";
    tfspush = "tofu state push terraform.tfstate";
    tfr = "tofu refresh";
    tfimport = "tofu import";
    tibu = "tofu init -backend-config=backend.hcl -upgrade";
  };
in
{
  inherit aliases;
}
